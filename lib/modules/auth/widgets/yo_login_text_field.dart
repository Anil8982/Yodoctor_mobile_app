import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class YoLoginTextField extends StatefulWidget {
  final Color color;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;

  const YoLoginTextField({
    super.key,
    required this.color,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.enabled = true,
  });

  @override
  State<YoLoginTextField> createState() => _YoLoginTextFieldState();
}

class _YoLoginTextFieldState extends State<YoLoginTextField> {
  bool _obscure = true;
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final containerBg = widget.enabled
        ? colorScheme.surface
        : colorScheme.surfaceContainerHighest.transparency(0.3);
    final sideBoxBg = widget.enabled
        ? (_errorText != null ? colorScheme.error : widget.color)
        : colorScheme.outlineVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: containerBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _errorText != null
                  ? colorScheme.error
                  : (_isFocused && widget.enabled
                        ? widget.color
                        : colorScheme.outlineVariant),
              width: _isFocused && widget.enabled || _errorText != null ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: sideBoxBg,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Icon(
                  widget.prefixIcon,
                  color: widget.enabled
                      ? AppTheme.white
                      : colorScheme.onSurfaceVariant.transparency(0.5),
                  size: 22,
                ),
              ),
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  enabled: widget.enabled,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _errorText = error;
                        });
                      }
                    });
                    return error != null ? '' : null;
                  },

                  keyboardType: widget.keyboardType,
                  obscureText: widget.isPassword && _obscure,
                  cursorColor: widget.color,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.enabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.transparency(0.5),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.transparency(0.6),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    isDense: true,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                    errorStyle: const TextStyle(height: 0, fontSize: 0),

                    suffixIcon: widget.isPassword && widget.enabled
                        ? Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: widget.color,
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() => _obscure = !_obscure);
                              },
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
          child: _errorText != null && _errorText!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Text(
                    _errorText!,
                    style: TextStyle(
                      color: colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
