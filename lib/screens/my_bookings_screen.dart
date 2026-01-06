import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/controller/booking_controller.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart'; // افترضت أن هذا ملف تعديل الحجز
import 'package:apartment_rental_app/widgets/booking_card.dart';
import 'package:apartment_rental_app/widgets/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}
// ... (الواردات المذكورة في كودك تبقى كما هي)

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bookingProvider.notifier).fetchMyBookings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. تعريف المتغيرات التي سيتم تمريرها للدوال
    final texts = ref.watch(stringsProvider); 
    final bookingState = ref.watch(bookingProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            texts.myBookings, // استخدام الترجمة للعنوان
            style: theme.appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
          Tab(text: texts.activeBookings), 
  
  Tab(text: texts.history), 
  
  Tab(text: texts.archived),
            ],
          ),
        ),
        body: bookingState.isLoading
            ? Center(
                child: CircularProgressIndicator(color: theme.primaryColor),
              )
            : TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // 3. تمرير 'texts' هنا لحل مشكلة الإيرور
                  _buildList(bookingState.currentBookings, "active", isDark, texts),
                  _buildList(bookingState.historyBookings, "history", isDark, texts),
                  _buildList(bookingState.cancelledBookings, "cancelled", isDark, texts),
                ],
              ),
      ),
    );
  }

  // 4. تأكد أن تعريف الدالة يستقبل texts في النهاية
  Widget _buildList(List<dynamic> bookings, String type, bool isDark, AppStrings texts) {
    final theme = Theme.of(context);

    if (bookings.isEmpty) {
      String emptyMessage;
      IconData emptyIcon;

      if (type == "active") {
        emptyMessage = texts.noActiveBookings;
        emptyIcon = Icons.calendar_today_rounded;
      } else if (type == "history") {
        emptyMessage = texts.noPastBookings;
        emptyIcon = Icons.history_rounded;
      } else {
        emptyMessage = texts.noCancelledBookings;
        emptyIcon = Icons.cancel_presentation_rounded;
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              emptyIcon,
              size: 60,
              color: isDark ? Colors.white10 : Colors.grey[300],
            ),
            const SizedBox(height: 15),
            Text(
              emptyMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final String status = booking['status'] ?? "";

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: BookingCard(
            booking: booking,
            isCancelled: type == "cancelled",
            isHistory: type == "history",
            status: status,
            onCancel: () => _showCancelDialog(booking['id'], texts), // تمرير المترجم للدايلوج
            onReview: (status.toLowerCase() == 'completed')
                ? () {
                    final bId = booking['id'];
                    final aId = booking['apartment_id'] ?? booking['apartment']?['id'];
                    if (aId != null) {
                      showRatingDialog(context, ref, bId, aId, booking['apartment']?['title'] ?? "Apartment");
                    }
                  }
                : null,
            onEdit: status.toLowerCase() == "pending"
                ? () async {
                    final apartmentData = booking['apartment'] ?? {};
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingApp(
                          apartmentId: booking['apartment_id'],
                          pricePerNight: (apartmentData['price'] as num? ?? 0.0).toDouble(),
                          bookingId: booking['id'],
                          initialStart: DateTime.parse(booking['start_date']),
                          initialEnd: DateTime.parse(booking['end_date']),
                        ),
                      ),
                    );
                    if (result == true) {
                      ref.read(bookingProvider.notifier).fetchMyBookings();
                    }
                  }
                : null,
          ),
        );
      },
    );
  }

  // 5. تعديل الدايلوج ليدعم الترجمة أيضاً
  void _showCancelDialog(int bookingId, AppStrings texts) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          texts.logout, // أو استخدم نص مترجم للإلغاء إذا وجد
          style: const TextStyle(color: kPrimaryColor),
        ),
        content: Text(texts.areYouSureLogout), // يفضل استبدالها بـ areYouSureCancel في AppStrings
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(texts.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(bookingProvider.notifier).cancelBooking(bookingId);
            },
            child: Text(texts.yes, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}