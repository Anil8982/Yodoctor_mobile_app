import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class EnquiryCard extends StatelessWidget {
  const EnquiryCard({
    super.key,
    required this.enquiry,
    required this.isExpanded,
    required this.onTap,
    required this.onDelete,
    required this.onResolve,
  });

  final dynamic enquiry;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onResolve;

  static const Color adminPrimary = Color(0xFF8A63B5);

  Color _statusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case "resolved":
        return AppTheme.success(context);

      case "pending":
        return AppTheme.pending(context);

      case "cancelled":
        return AppTheme.error(context);

      default:
        return AppTheme.info(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = enquiry.status ?? "Pending";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8F5FF)],
        ),
        border: Border.all(
          color: const Color.fromARGB(255, 187, 34, 179).transparency(.15),
        ),
        boxShadow: [
          BoxShadow(
            color: adminPrimary.transparency(.08),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [adminPrimary.transparency(.08), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: adminPrimary,
                      child: Text(
                        enquiry.name.toString().substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            enquiry.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            enquiry.email,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(context, status).transparency(.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: _statusColor(context, status),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: adminPrimary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _detailTile(Icons.phone_outlined, "Phone", enquiry.mobile ?? "-"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _detailTile(Icons.subject_outlined, "Concern", enquiry.concern ?? "-")),
                      const SizedBox(width: 12),
                      Expanded(child: _detailTile(Icons.category_outlined, "Sub Concern", enquiry.subConcern ?? "-")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _detailTile(Icons.calendar_today_outlined, "Date", enquiry.date ?? "-"),
                  const SizedBox(height: 10),
                  _detailTile(Icons.message_outlined, "Message", enquiry.message ?? "-"),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onResolve,
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text("Resolve", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: adminPrimary,
                            side: const BorderSide(color: adminPrimary),
                            minimumSize: const Size(0, 38),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline, size: 16),
                          label: const Text("Delete", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 38),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: adminPrimary.transparency(.10),
          child: Icon(icon, color: adminPrimary, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}