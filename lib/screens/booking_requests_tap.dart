import 'dart:ui';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/providers/booking_provider.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingRequestsTap extends ConsumerStatefulWidget {
  const BookingRequestsTap({super.key});

  @override
  ConsumerState<BookingRequestsTap> createState() => _BookingRequestsTapState();
}

class _BookingRequestsTapState extends ConsumerState<BookingRequestsTap> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(bookingProvider.notifier).fetchOwnerRequests());
  }

  @override
  Widget build(BuildContext context) {
    // جلب النصوص والثيم
    final texts = ref.watch(stringsProvider);
    final state = ref.watch(bookingProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state.isLoading) {
      return Center(
          child: CircularProgressIndicator(color: theme.primaryColor));
    }

    if (state.pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy,
                size: 80, color: isDark ? Colors.white10 : Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              texts.noData, // النص الحرفي "لا يوجد بيانات"
              style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: state.pendingRequests.length,
      itemBuilder: (context, index) {
        final request = state.pendingRequests[index];
        final status = request.status.toLowerCase().trim();

        return Card(
          elevation: isDark ? 0 : 4,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side:
                BorderSide(color: isDark ? Colors.white10 : Colors.transparent),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ApartmentDetailsScreen(apartmentId: request.apartmentId),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: Icon(Icons.person, color: theme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${texts.userIdLabel}: ${request.userId}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                      isDark ? Colors.white : Colors.black87),
                            ),
                            // استدعاء الميثود مع تمرير الـ texts للترجمة
                            _buildStatusBadge(request.status, texts),
                          ],
                        ),
                      ),
                      Text(
                        "${request.totalPrice} \$",
                        style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.arrow_forward_ios,
                          size: 12,
                          color: isDark ? Colors.white38 : Colors.grey),
                    ],
                  ),
                  Divider(
                      height: 30,
                      color: isDark ? Colors.white10 : Colors.grey[200]),
                  // داخل ListView.builder في ملف BookingRequestsTap
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ركزنا التاريخ هون
                      _infoColumn(texts.checkInDate,
                          texts.formatDate(request.startDate), isDark),

                      // سهم صغير للجمالية مثل ما عملنا بالكارد
                      Icon(Icons.arrow_forward_rounded,
                          size: 16,
                          color: isDark ? Colors.white10 : Colors.grey[200]),

                      // وركزنا التاريخ هون كمان
                      _infoColumn(texts.checkOutDate,
                          texts.formatDate(request.endDate), isDark),
                    ],
                  ),
                  if (status == 'pending') ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => ref
                                .read(bookingProvider.notifier)
                                .acceptRequest(request.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(texts.accept), // "قبول" حرفياً
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => ref
                                .read(bookingProvider.notifier)
                                .rejectRequest(request.id),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(texts.rejected), // "مرفوضة" حرفياً
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        texts.viewDetailsMsg, // "اضغط لعرض تفاصيل الشقة"
                        style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ميثود عرض الحالة مع الترجمة الحرفية
  Widget _buildStatusBadge(String status, AppStrings texts) {
    Color color;
    // نستخدم ميثود translate الموجود بملفك لترجمة الحالة القادمة من السيرفر
    String translatedStatus = texts.translate(status.trim());

    switch (status.toLowerCase().trim()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'accepted':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      case 'cancelled':
        color = Colors.grey;
        break;
      default:
        color = Colors.black;
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        translatedStatus,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  // عمود المعلومات مع دعم المود
  Widget _infoColumn(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, color: isDark ? Colors.white38 : Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87)),
      ],
    );
  }
}
