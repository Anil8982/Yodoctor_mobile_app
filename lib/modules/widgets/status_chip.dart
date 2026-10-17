import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

enum Status {
  // Core States
  active,
  inactive,
  pending,
  success,
  warning,
  error,
  info,
  cancelled,
  completed,
  confirmed,
  accepted,
  rejected,
  processing,

  // Appointment Specific
  booked,
  rescheduled,
  checkedIn,
  consulting,
  missed,

  // Certificate Specific
  verification,
  issued,
  approved,
  fit,
  unfit,
  temporarilyUnfit,

  // Custom State
  custom,
}

class StatusChip extends StatelessWidget {
  final dynamic status; // Can accept String, Status Enum, or custom string
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Color? customColor; // Custom color support
  final IconData? icon; // Custom/Override icon parameter
  final bool isSmall; // Compact mode toggle

  const StatusChip({
    super.key,
    required this.status,
    this.padding,
    this.fontSize,
    this.customColor,
    this.icon,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final _StatusConfig config = _resolveStatusConfig(context, status);

    // Dynamic padding & sizing for isSmall flag
    final EdgeInsetsGeometry resolvedPadding =
        padding ??
        (isSmall
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 6));

    final double resolvedFontSize = fontSize ?? (isSmall ? 10 : 11);
    final double resolvedIconSize = resolvedFontSize + 2;

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: resolvedIconSize,
            color: config.foregroundColor,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              config.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                color: config.foregroundColor,
                fontWeight: FontWeight.w800,
                fontSize: resolvedFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _resolveStatusConfig(
    BuildContext context,
    dynamic inputStatus,
  ) {
    String rawString = '';
    Status? matchedEnum;

    if (customColor != null) {
      matchedEnum = Status.custom;
      rawString = inputStatus is Status
          ? _formatEnumName(inputStatus.name)
          : inputStatus.toString().trim();
    } else if (inputStatus is Status) {
      matchedEnum = inputStatus;
      rawString = _formatEnumName(inputStatus.name);
    } else {
      rawString = inputStatus.toString().trim();
      matchedEnum = _matchStringToEnum(rawString);
    }

    final String displayLabel = rawString.isNotEmpty
        ? rawString
        : (matchedEnum != null ? _formatEnumName(matchedEnum.name) : 'Info');

    Color statusColor;
    IconData resolvedIcon;

    if (customColor != null) {
      statusColor = customColor!;
      resolvedIcon = icon ?? Icons.info_rounded;
    } else {
      switch (matchedEnum) {
        case Status.success:
        case Status.completed:
        case Status.issued:
        case Status.approved:
        case Status.fit:
          statusColor = AppTheme.success(context);
          resolvedIcon = matchedEnum == Status.fit
              ? Icons.check_circle_outline_rounded
              : Icons.check_circle_rounded;
          break;

        case Status.confirmed:
          statusColor = AppTheme.success(context);
          resolvedIcon = Icons.verified_rounded;
          break;

        case Status.accepted:
          statusColor = AppTheme.success(context);
          resolvedIcon = Icons.check_circle_rounded;
          break;

        case Status.booked:
          statusColor = AppTheme.success(context);
          resolvedIcon = Icons.event_available_rounded;
          break;

        case Status.checkedIn:
          statusColor = AppTheme.success(context);
          resolvedIcon = Icons.how_to_reg_rounded;
          break;

        case Status.active:
          statusColor = AppTheme.active(context);
          resolvedIcon = Icons.check_circle_rounded;
          break;

        case Status.cancelled:
        case Status.rejected:
        case Status.error:
        case Status.missed:
        case Status.unfit:
          statusColor = AppTheme.error(context);
          resolvedIcon = matchedEnum == Status.missed
              ? Icons.event_busy_rounded
              : (matchedEnum == Status.error
                    ? Icons.error_rounded
                    : (matchedEnum == Status.unfit
                          ? Icons.cancel_outlined
                          : Icons.cancel_rounded));
          break;

        case Status.inactive:
          statusColor = AppTheme.inactive(context);
          resolvedIcon = Icons.block_rounded;
          break;

        case Status.pending:
        case Status.rescheduled:
        case Status.consulting:
        case Status.verification:
        case Status.temporarilyUnfit:
          statusColor = AppTheme.warning(context);
          resolvedIcon = matchedEnum == Status.rescheduled
              ? Icons.update_rounded
              : (matchedEnum == Status.consulting
                    ? Icons.medical_services_rounded
                    : (matchedEnum == Status.temporarilyUnfit
                          ? Icons.hourglass_empty_rounded
                          : Icons.schedule_rounded));
          break;

        case Status.processing:
          statusColor = AppTheme.pending(context);
          resolvedIcon = Icons.sync_rounded;
          break;

        case Status.warning:
          statusColor = AppTheme.warning(context);
          resolvedIcon = Icons.warning_amber_rounded;
          break;

        case Status.info:
        case Status.custom:
        default:
          statusColor = AppTheme.info(context);
          resolvedIcon = Icons.info_rounded;
          break;
      }
    }

    if (icon != null && customColor == null) {
      resolvedIcon = icon!;
    }

    return _StatusConfig(
      label: displayLabel,
      backgroundColor: statusColor.transparency(0.1).pastel(0.80),
      borderColor: statusColor,
      foregroundColor: statusColor,
      icon: resolvedIcon,
    );
  }

  Status? _matchStringToEnum(String value) {
    final upper = value.toUpperCase();

    if (upper.contains('CANCEL') || upper.contains('REJECT')) {
      return Status.cancelled;
    }
    if (upper.contains('COMPLET')) return Status.completed;
    if (upper.contains('CONFIRM')) return Status.confirmed;
    if (upper.contains('ACCEPT')) return Status.accepted;
    if (upper.contains('PEND') || upper.contains('WAIT')) return Status.pending;
    if (upper.contains('ACTIVE')) return Status.active;
    if (upper.contains('INACTIVE')) return Status.inactive;
    if (upper.contains('WARN')) return Status.warning;
    if (upper.contains('ERR') || upper.contains('FAIL')) return Status.error;
    if (upper.contains('PROCESS')) return Status.processing;
    if (upper.contains('SCHEDULE') || upper.contains('RESCHEDULE')) {
      return Status.rescheduled;
    }
    if (upper.contains('BOOK')) return Status.booked;
    if (upper.contains('CHECK')) return Status.checkedIn;
    if (upper.contains('CONSULT')) return Status.consulting;
    if (upper.contains('MISSED')) return Status.missed;

    //payment mappings
    if (upper.contains('PAID')) return Status.success;
    if (upper.contains('REFUNDED')) return Status.info;

    // Certificate mappings
    if (upper.contains('VERIF')) return Status.verification;
    if (upper.contains('ISSUED')) return Status.issued;
    if (upper.contains('APPROV')) return Status.approved;
    if (upper == 'FIT') return Status.fit;
    if (upper == 'UNFIT') return Status.unfit;
    if (upper.contains('TEMP') || upper.contains('TEMPORARILY')) {
      return Status.temporarilyUnfit;
    }

    for (var status in Status.values) {
      if (status.name.toUpperCase() == upper) {
        return status;
      }
    }

    return Status.info;
  }

  String _formatEnumName(String name) {
    final result = name.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' ');
    if (result.isEmpty) return '';
    return result[0].toUpperCase() + result.substring(1);
  }
}

class _StatusConfig {
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.icon,
  });
}
