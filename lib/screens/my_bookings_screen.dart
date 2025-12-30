import 'package:apartment_rental_app/controller/booking_controller.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/widgets/booking_card.dart';
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
      length: 2,
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
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: Stack(
          children: [
        
            bookingState.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: theme.primaryColor),
                  )
                : TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildList(bookingState.currentBookings, false, isDark),
                      _buildList(bookingState.cancelledBookings, true, isDark),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> bookings, bool isArchive, bool isDark) {
    final theme = Theme.of(context);
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isArchive ? Icons.history_rounded : Icons.calendar_today_rounded,
              size: 60,
              color: isDark ? Colors.white10 : Colors.grey[300],
            ),
            const SizedBox(height: 15),
            Text(
              isArchive ? "No cancelled bookings" : "No active bookings",
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: BookingCard(
            booking: bookings[index],
            isCancelled: isArchive,
            onCancel: () => _showCancelDialog(bookings[index]['id']),
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingApp(
                    apartmentId: bookings[index]['apartment_id'],
                    pricePerNight: int.parse(
                      bookings[index]['total_price'].toString(),
                    ),
                    bookingId: bookings[index]['id'],
                    initialStart: DateTime.parse(bookings[index]['start_date']),
                    initialEnd: DateTime.parse(bookings[index]['end_date']),
                  ),
                ),
              );
              if (result == true) {
                ref.read(bookingProvider.notifier).fetchMyBookings();
              }
            },
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.dividerColor, width: 1.2),
        ),
        title: Text(
          "Cancel Booking",
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
        ),
        content: Text(
          "Are you sure you want to cancel this reservation?",
          style: theme.textTheme.bodyMedium,
        ),
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
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}