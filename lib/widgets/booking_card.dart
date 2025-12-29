import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final dynamic booking;
  final VoidCallback? onCancel;
  final VoidCallback? onEdit;
  final bool isCancelled;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
    this.isCancelled = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(

        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.dividerColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 24, 24, 24).withOpacity(isDark ? 0.4 : 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Booking #${booking['id']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              _buildStatusBadge(booking['status'], isDark),
            ],
          ),
          Divider(height: 24, thickness: 1, color: theme.dividerColor),
          _buildInfoRow(
            Icons.calendar_today,
            "From: ${booking['start_date']}",
            isDark,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.event, "To: ${booking['end_date']}", isDark),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${booking['total_price']} \$",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : theme.primaryColor,
                ),
              ),
              Row(
                children: [
                  if (!isCancelled && booking['status'] != 'cancelled')
                    TextButton(
                      onPressed: onEdit,
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (!isCancelled && booking['status'] != 'cancelled')
                    TextButton(
                      onPressed: onCancel,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white54 : const Color(0xFF555555),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color color = status == 'pending'
        ? Colors.orange
        : (status == 'cancelled' ? Colors.red : Colors.green);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
