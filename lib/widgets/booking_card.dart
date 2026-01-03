import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class BookingCard extends StatelessWidget {
  final dynamic booking;
  final bool isCancelled;
  final bool isHistory;
  final String? status;
  final VoidCallback? onCancel;
  final VoidCallback? onEdit;
  final VoidCallback? onReview;

  const BookingCard({
    super.key,
    required this.booking,
    this.isCancelled = false,
    this.isHistory = false,
    this.status,
    this.onCancel,
    this.onEdit,
    this.onReview,
  });

  bool hasBeenRated() {
    var rated = booking['is_rated'];
    return rated.toString() == "1" || rated.toString() == "true";
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String currentStatus = (status ?? "pending").toLowerCase();
    
    final Color mainTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color secondaryTextColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    Color statusColor;
    switch (currentStatus) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'accepted':
        statusColor = Colors.blue;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'rejected':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark 
                ? Colors.black.withOpacity(0.3) 
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Booking #${booking['id']}",
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark 
                              ? Colors.white 
                              : kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${formatDate(booking['start_date'])} to ${formatDate(booking['end_date'])}",
                        style: TextStyle(
                          color: secondaryTextColor, 
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    currentStatus.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStatus == 'completed')
                  if (!hasBeenRated())
                    ElevatedButton.icon(
                      onPressed: onReview,
                      icon: const Icon(Icons.star_rate, size: 16),
                      label: const Text("Rate Now"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "Rated",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                else
                  const SizedBox(),
                
                if (currentStatus == 'pending')
                  Row(
                    children: [
                      TextButton(
                        onPressed: onCancel,
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.brightness == Brightness.dark 
                              ? Colors.white 
                              : kPrimaryColor,
                          foregroundColor: theme.brightness == Brightness.dark 
                              ? kPrimaryColor 
                              : Colors.white,
                        ),
                        child: const Text("Edit"),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}