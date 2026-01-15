import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/models/booking_request_model.dart';
import 'package:apartment_rental_app/providers/booking_provider.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart'; 
import 'package:apartment_rental_app/widgets/booking_card.dart';
import 'package:apartment_rental_app/widgets/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bookingProvider.notifier).fetchMyBookings());
  }

  @override
  Widget build(BuildContext context) {
    final texts = ref.watch(stringsProvider); 
    final bookingState = ref.watch(bookingProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(texts.myBookings),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: texts.activeBookings), 
              Tab(text: texts.history), 
              Tab(text: texts.archived),
            ],
          ),
        ),
        body: bookingState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildList(bookingState.currentBookings, "active", isDark, texts),
                  _buildList(bookingState.historyBookings, "history", isDark, texts),
                  _buildList(bookingState.cancelledBookings, "cancelled", isDark, texts),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List<BookingRequestModel> bookings, String type, bool isDark, AppStrings texts) {
    if (bookings.isEmpty) {
      return _buildEmptyWidget(type, isDark, texts);
    }
    
    return RefreshIndicator(
      onRefresh: () => ref.read(bookingProvider.notifier).fetchMyBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(
            booking: booking,
            isCancelled: type == "cancelled",
            isHistory: type == "history",
            status: booking.status,
            onCancel: () => _showCancelDialog(booking.id, texts),
            onReview: (booking.status.toLowerCase() == 'completed' && booking.isRated == 0)
                ? () => showRatingDialog(context, ref, booking.id, booking.apartmentId, "Apartment")
                : null,
            onEdit: (booking.status.toLowerCase() == "pending")
                ? () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingApp(
                          apartmentId: booking.apartmentId,
                          bookingId: booking.id,
                          pricePerNight: 0.0, 
                          initialStart: DateTime.parse(booking.startDate),
                          initialEnd: DateTime.parse(booking.endDate),
                        ),
                      ),
                    );
                    
                    if (result == true) {
                      ref.read(bookingProvider.notifier).fetchMyBookings();
                    }
                  }
                : null,
          );
        },
      ),
    );
  }

  Widget _buildEmptyWidget(String type, bool isDark, AppStrings texts) {
    IconData icon = type == "active" 
        ? Icons.calendar_today 
        : (type == "history" ? Icons.history : Icons.cancel);
    
    String msg = type == "active" 
        ? texts.noActiveBookings 
        : (type == "history" ? texts.noPastBookings : texts.noCancelledBookings);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: isDark ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 15),
          Text(
            msg, 
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(int bookingId, AppStrings texts) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          texts.cancelBooking, 
          style: const TextStyle(color: Color(0xFF234F68), fontWeight: FontWeight.bold)
        ),
        content: Text(texts.areYouSureCancel),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(texts.no),
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