import 'dart:async';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/providers/otp_cooldown_provider.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';

typedef OtpVerifyCallback = Future<dynamic> Function(String otp);
typedef OtpResendCallback = Future<dynamic> Function();

class OtpBottomSheet extends ConsumerStatefulWidget {
  final String? verificationId;
  final String? channel;
  final String? mobile;
  final String? maskedDestination;
  final Color primaryColor;
  final OtpVerifyCallback onVerify;
  final OtpResendCallback onResend;

  const OtpBottomSheet({
    super.key,
    this.verificationId,
    this.channel,
    this.mobile,
    this.maskedDestination,
    required this.primaryColor,
    required this.onVerify,
    required this.onResend,
  });

  static Future<bool?> show({
    required BuildContext context,
    String? verificationId,
    String? channel,
    String? mobile,
    String? maskedDestination,
    required Color primaryColor,
    required OtpVerifyCallback onVerify,
    required OtpResendCallback onResend,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (ctx) => OtpBottomSheet(
        verificationId: verificationId,
        channel: channel,
        mobile: mobile,
        maskedDestination: maskedDestination,
        primaryColor: primaryColor,
        onVerify: onVerify,
        onResend: onResend,
      ),
    );
  }

  @override
  ConsumerState<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends ConsumerState<OtpBottomSheet>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  Timer? _timer;
  Timer? _successMessageTimer;
  int _secondsRemaining = 0;
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;
  String? _resendSuccessMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: -3.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -3.0, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );

    // Sync remaining seconds from controller timestamp
    _syncRemainingSeconds();
    _startCooldownTimer();

    _otpController.addListener(_onOtpChanged);
    _otpFocusNode.addListener(_onFocusChanged);

    // Reliable auto-request focus and ensure cooldown is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _otpFocusNode.requestFocus();
        final currentExpiry = ref.read(otpCooldownProvider);
        if (currentExpiry == null || currentExpiry.isBefore(DateTime.now())) {
          ref.read(otpCooldownProvider.notifier).startCooldown();
          setState(() {
            _syncRemainingSeconds();
            _startCooldownTimer();
          });
        }
      }
    });
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onOtpChanged() {
    if (mounted) {
      if (_errorMessage != null || _resendSuccessMessage != null) {
        setState(() {
          _errorMessage = null;
          _resendSuccessMessage = null;
        });
      } else {
        setState(() {});
      }
      if (_otpController.text.trim().length == 6 &&
          !_isVerifying &&
          !_isResending) {
        _handleVerify();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && mounted) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted || _isVerifying || _isResending) return;

        _otpFocusNode.unfocus();

        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted || _isVerifying || _isResending) return;

          _otpFocusNode.requestFocus();
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _successMessageTimer?.cancel();
    _shakeController.dispose();
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _otpFocusNode.removeListener(_onFocusChanged);
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _syncRemainingSeconds() {
    final expiry = ref.read(otpCooldownProvider);
    if (expiry != null) {
      final diff = expiry.difference(DateTime.now()).inSeconds;
      _secondsRemaining = diff > 0 ? diff : 0;
    } else {
      _secondsRemaining = 0;
    }
  }

  void _startCooldownTimer() {
    _timer?.cancel();
    _syncRemainingSeconds();
    if (_secondsRemaining <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _syncRemainingSeconds();
        if (_secondsRemaining <= 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _handleVerify() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) return;
    if (_isVerifying || _isResending) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
      _resendSuccessMessage = null;
    });

    try {
      final result = await widget.onVerify(otp);
      if (!mounted) return;

      if (result == true || result == null) {
        Navigator.of(context).pop(true);
      } else if (result is String && result.isNotEmpty) {
        _shakeController.forward(from: 0.0);
        setState(() {
          _isVerifying = false;
          _errorMessage = result;
        });
      } else {
        _shakeController.forward(from: 0.0);
        setState(() {
          _isVerifying = false;
          _errorMessage = 'Invalid verification code. Please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      _shakeController.forward(from: 0.0);
      setState(() {
        _isVerifying = false;
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    }
  }

  Future<void> _handleResend() async {
    _syncRemainingSeconds();
    if (_secondsRemaining > 0 || _isResending || _isVerifying) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
      _resendSuccessMessage = null;
    });

    try {
      final result = await widget.onResend();
      if (!mounted) return;

      setState(() {
        _isResending = false;
      });

      if (result == true || result == null) {
        _otpController.clear();
        ref.read(otpCooldownProvider.notifier).startCooldown();
        _startCooldownTimer();
        setState(() {
          _resendSuccessMessage = 'New OTP sent successfully.';
        });
        _successMessageTimer?.cancel();
        _successMessageTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _resendSuccessMessage = null;
            });
          }
        });
        _otpFocusNode.requestFocus();
      } else if (result is String && result.isNotEmpty) {
        setState(() {
          _errorMessage = result;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to resend OTP. Please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isResending = false;
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    }
  }

  String _getSupportingText() {
    if (widget.maskedDestination != null &&
        widget.maskedDestination!.isNotEmpty) {
      return 'Enter the 6-digit OTP sent to ${widget.maskedDestination}.';
    }

    final channelUpper = widget.channel?.toUpperCase();
    if (channelUpper == 'EMAIL') {
      return 'Enter the 6-digit OTP sent to your registered email address.';
    } else if (channelUpper == 'SMS' ||
        (widget.mobile != null && widget.mobile!.isNotEmpty)) {
      final dest = widget.mobile != null && widget.mobile!.isNotEmpty
          ? widget.mobile!
          : 'registered mobile number';
      return 'Enter the 6-digit OTP sent to $dest.';
    }

    return 'Enter the 6-digit OTP sent to your account.';
  }

  Widget _buildOtpDigitBoxes(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentText = _otpController.text;
    final hasError = _errorMessage != null && _errorMessage!.isNotEmpty;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!_otpFocusNode.hasFocus) {
            _otpFocusNode.requestFocus();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Invisible input taking user touch and keyboard events
            Opacity(
              opacity: 0.0,
              child: TextField(
                controller: _otpController,
                focusNode: _otpFocusNode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                enableSuggestions: false,
                autocorrect: false,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            // Visible 6 Styled Digit Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                final isFilled = index < currentText.length;
                final isFocused =
                    _otpFocusNode.hasFocus && index == currentText.length;
                final digit = isFilled ? currentText[index] : '';

                Color borderColor;
                double borderWidth;
                Color boxBgColor;

                if (hasError) {
                  borderColor = colorScheme.error;
                  borderWidth = 1.5;
                  boxBgColor = colorScheme.error.transparency(0.04);
                } else if (isFocused) {
                  borderColor = widget.primaryColor;
                  borderWidth = 2.0;
                  boxBgColor = colorScheme.surface;
                } else if (isFilled) {
                  borderColor = widget.primaryColor.transparency(0.45);
                  borderWidth = 1.5;
                  boxBgColor = colorScheme.surface;
                } else {
                  borderColor = colorScheme.outlineVariant.transparency(0.8);
                  borderWidth = 1.2;
                  boxBgColor = colorScheme.surfaceContainerLow;
                }

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!_otpFocusNode.hasFocus) {
                      _otpFocusNode.requestFocus();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: boxBgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: borderColor,
                        width: borderWidth,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: widget.primaryColor.transparency(0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : (isFilled
                                ? [
                                    BoxShadow(
                                      color: AppTheme.black.transparency(0.03),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null),
                    ),
                    alignment: Alignment.center,
                    child: isFocused && digit.isEmpty
                        ? Container(
                            width: 2,
                            height: 22,
                            decoration: BoxDecoration(
                              color: widget.primaryColor,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          )
                        : Text(
                            digit,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: colorScheme.onSurface,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final isOtpComplete = _otpController.text.trim().length == 6;
    final canVerify = isOtpComplete && !_isVerifying && !_isResending;
    final canResend = _secondsRemaining == 0 && !_isResending && !_isVerifying;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.transparency(0.12),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant.transparency(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header with Title and Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: widget.primaryColor.transparency(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            color: widget.primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Verify OTP',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: (_isVerifying || _isResending)
                          ? null
                          : () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Supporting Subtitle
                Text(
                  _getSupportingText(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // 6-digit OTP input boxes with reliable focus gesture handling
                _buildOtpDigitBoxes(context),

                const SizedBox(height: 8),

                // Fixed-height message area (no border/card/background/icon; prevents any vertical layout shift)
                SizedBox(
                  height: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: (_errorMessage != null && _errorMessage!.isNotEmpty)
                        ? Text(
                            _errorMessage!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : (_resendSuccessMessage != null &&
                              _resendSuccessMessage!.isNotEmpty)
                        ? Text(
                            _resendSuccessMessage!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: widget.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                const SizedBox(height: 16),

                // Verify Primary Button
                YoPrimaryButton(
                  label: 'Verify & Proceed',
                  color: widget.primaryColor,
                  isLoading: _isVerifying,
                  onTap: canVerify ? _handleVerify : null,
                ),

                const SizedBox(height: 16),

                // Resend OTP Action & Cooldown Row
                Center(
                  child: _isResending
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: widget.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Sending new code...',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: widget.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : TextButton(
                          onPressed: canResend ? _handleResend : null,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Didn't receive the code? ",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                TextSpan(
                                  text: canResend
                                      ? 'Resend OTP'
                                      : 'Resend OTP in ${_secondsRemaining}s',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: canResend
                                        ? widget.primaryColor
                                        : colorScheme.outline,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
