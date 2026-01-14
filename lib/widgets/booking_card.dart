import 'package:apartment_rental_app/models/booking_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/constants/app_string.dart';

class BookingCard extends ConsumerWidget {
  final BookingRequestModel booking;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(stringsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // توحيد حالة الحجز
    final String currentStatus =
        (status ?? booking.status).toLowerCase().trim();

    // تحديد لون الحالة بناءً على نوعها
    Color statusColor;
    switch (currentStatus) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'accepted':
      case 'confirmed':
        statusColor = Colors.green;
        break;
      case 'rejected':
      case 'cancelled':
        statusColor = Colors.redAccent;
        break;
      case 'completed':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        // إضافة حدود خفيفة في الوضع الليلي لزيادة التباين
        border: Border.all(color: isDark ? Colors.white10 : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // السطر العلوي: الأيقونة، الرقم، والحالة
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child:
                      Icon(Icons.apartment_rounded, color: theme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${texts.myBookings} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildStatusBadge(currentStatus, texts, statusColor),
                    ],
                  ),
                ),
                // السعر
                Text(
                  "${booking.totalPrice} \$",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            Divider(
                height: 30, color: isDark ? Colors.white10 : Colors.grey[200]),

        Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    // نستخدم texts.formatDate لتركيز التاريخ
    _infoColumn(texts.checkInDate, texts.formatDate(booking.startDate), isDark),
    
    Icon(Icons.arrow_forward_rounded, size: 16, color: isDark ? Colors.white24 : Colors.grey[300]),
    
    // ونفس الشيء لتاريخ الخروج
    _infoColumn(texts.checkOutDate, texts.formatDate(booking.endDate), isDark),
  ],
),

            // الأزرار التفاعلية
            if (currentStatus == 'pending') ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child:
                          Text(texts.edit), // تم التغيير لـ texts.edit للترجمة
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        foregroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(texts.cancel),
                    ),
                  ),
                ],
              ),
            ] else if (currentStatus == 'completed') ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onReview,
                  icon: const Icon(Icons.star_rate, size: 18),
                  label: Text(
                      texts.rateNow), // تم التغيير لـ texts.rateNow للترجمة
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ودجت صغيرة لعلامة الحالة (Badge)
  Widget _buildStatusBadge(String status, AppStrings texts, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        texts.translate(status), // استخدام دالة الترجمة السحرية
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ودجت لعمود المعلومات (التاريخ)
  Widget _infoColumn(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white38 : Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
