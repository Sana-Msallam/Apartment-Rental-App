import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/constants/app_string.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class BookingCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(stringsProvider);
    final theme = Theme.of(context);
    final String currentStatus = (status ?? "pending").toLowerCase();
    final Color secondaryTextColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;
Color statusColor;
String statusLabel;
   switch (currentStatus) {
      case 'completed':
        statusColor = Colors.green;
        statusLabel = texts.history; // "السجل" أو "مكتملة"
        break;
      case 'accepted':
        statusColor = Colors.blue;
        statusLabel = texts.activeBookings; // "نشطة" أو "مقبولة"
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusLabel = texts.activeBookings; // "نشطة" أو "قيد الانتظار"
        break;
      case 'rejected': // هنا التمييز للمرفوضة
        statusColor = Colors.redAccent;
        // إذا كانت الواجهة إنجليزية يكتب Rejected وإذا عربية يكتب مرفوضة
        statusLabel = texts.addSuccess == "Success" ? "rejected" : "مرفوضة"; 
        break;
      case 'cancelled': // هنا التمييز للملغية
        statusColor = Colors.redAccent;
        // نستخدم texts.cancel لأنه غالباً يحتوي على كلمة "إلغاء" أو "Cancelled"
        statusLabel = texts.cancel; 
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = currentStatus.toUpperCase();
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
                        // 1. ترجمة كلمة حجز (تستخدم My Bookings من ملفك)
                        "${texts.myBookings} #${booking['id']}",
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark ? Colors.white : kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        // 2. ترجمة الرابط بين التواريخ (to أو إلى)
                        "${formatDate(booking['start_date'])} ${texts.cancel == "Cancel" ? "to" : "إلى"} ${formatDate(booking['end_date'])}",
                        style: TextStyle(color: secondaryTextColor, fontSize: 13),
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
                    statusLabel, // 3. الحالة مترجمة بالكامل
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
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
                      // 4. ترجمة زر قيم الآن
                      label: Text(texts.addSuccess == "Success" ? "Rate Now" : "قيم الآن"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          // 5. ترجمة كلمة "تم التقييم"
                          texts.addSuccess == "Success" ? "Rated" : "تم التقييم",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
                        child: Text(
                          texts.cancel, // 6. زر الإلغاء مترجم أصلاً في ملفك
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.brightness == Brightness.dark ? Colors.white : kPrimaryColor,
                          foregroundColor: theme.brightness == Brightness.dark ? kPrimaryColor : Colors.white,
                        ),
                        // 7. ترجمة زر التعديل
                        child: Text(texts.addSuccess == "Success" ? "Edit" : "تعديل"),
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