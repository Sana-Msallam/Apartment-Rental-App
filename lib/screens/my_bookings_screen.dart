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

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    // جلب الحجوزات عند فتح الصفحة
    Future.microtask(
      () => ref.read(bookingProvider.notifier).fetchMyBookings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3, // تم التعديل ليكون 3 تبويبات
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "My Reservations",
            style: theme.appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: "Active"),
              Tab(text: "History"),   // مكتمل ومرفوض
              Tab(text: "Cancelled"), // ملغي من المستخدم
            ],
          ),
        ),
        body: bookingState.isLoading
            ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
            : TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // نمرر نوع القائمة لكل دالة بناء
                  _buildList(bookingState.currentBookings, "active", isDark),
                  _buildList(bookingState.historyBookings, "history", isDark),
                  _buildList(bookingState.cancelledBookings, "cancelled", isDark),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List<dynamic> bookings, String type, bool isDark) {
    final theme = Theme.of(context);

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == "active" ? Icons.calendar_today_rounded : 
              type == "history" ? Icons.history_rounded : Icons.cancel_presentation_rounded,
              size: 60,
              color: isDark ? Colors.white10 : Colors.grey[300],
            ),
            const SizedBox(height: 15),
            Text(
              type == "active" ? "No active bookings" : 
              type == "history" ? "No past bookings" : "No cancelled bookings",
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
            // تحديد الخصائص بناءً على النوع
           isCancelled: type == "cancelled",
      // اجعلي isHistory تظهر true إذا كان التبويب هو history 👈
      isHistory: type == "history", 
      status: status,
      
      onCancel: () => _showCancelDialog(booking['id']),

onReview: (status.toLowerCase() == 'completed') ? () { 
    // تأكد أن المعرفات ليست Null
    final bId = booking['id'];
    final aId = booking['apartment_id'] ?? booking['apartment']?['id']; 

    if (aId != null) {
      showRatingDialog(
          context, 
          ref, 
          bId, 
          aId, 
          booking['apartment']?['title'] ?? "Apartment"
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Apartment ID not found"))
      );
    }
} : null,

onEdit: status.toLowerCase() == "pending" ? () async {
                final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingApp(
                    apartmentId: booking['apartment_id'],
pricePerNight: double.parse(booking['total_price'].toString()).round(),
                    bookingId: booking['id'],
                    initialStart: DateTime.parse(booking['start_date']),
                    initialEnd: DateTime.parse(booking['end_date']),
                  ),
                ),
              );
              if (result == true) {
                ref.read(bookingProvider.notifier).fetchMyBookings();
              }
            } : null,
          ),
        );
      },
    );
  }

 void _showCancelDialog(int bookingId) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Cancel Booking"),
        content: const Text("Are you sure you want to cancel this reservation?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(bookingProvider.notifier).cancelBooking(bookingId);
            },
            child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ), // إغلاق الـ AlertDialog
    ); // إغلاق الـ showDialog
  } // إغلاق الدالة _showCancelDialog
} // 👈 هذا هو القوس الأهم: إغلاق كلاس الـ _MyBookingsScreenState
