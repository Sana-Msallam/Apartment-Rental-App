import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:apartment_rental_app/widgets/date_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class BookingApp extends ConsumerStatefulWidget {
  final int apartmentId;
  final int pricePerNight;
  final int? bookingId;
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const BookingApp({
    super.key,
    required this.apartmentId,
    required this.pricePerNight,
    this.bookingId,
    this.initialStart,
    this.initialEnd,
  });

  @override
  ConsumerState<BookingApp> createState() => _BookingAppState();
}

class _BookingAppState extends ConsumerState<BookingApp> {
  DateTime? _startDate;
  DateTime? _endDate;

  final DateTime _firstDate = DateTime.now();
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 10));

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStart;
    _endDate = widget.initialEnd;
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? _firstDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      builder: (context, child) => _buildDatePickerTheme(context, child!),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      _showErrorSnackBar('Please select the start date first.');
      return;
    }
    final DateTime minRequiredEndDate = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate != null && _endDate!.isAfter(minRequiredEndDate)
          ? _endDate!
          : minRequiredEndDate,
      firstDate: minRequiredEndDate,
      lastDate: _lastDate,
      builder: (context, child) => _buildDatePickerTheme(context, child!),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Widget _buildDatePickerTheme(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.brightness == Brightness.dark
            ? theme.colorScheme.copyWith(
                primary: Colors.white,
                surface: const Color(0xFF22282A),
              )
            : theme.colorScheme.copyWith(primary: theme.primaryColor),
      ),
      child: child,
    );
  }

  void _submitBooking() async {
    if (_startDate == null || _endDate == null) {
      _showErrorSnackBar('Please select both dates.');
      return;
    }

     final storage = ref.read(storageProvider);
    String? token = await storage.read(key: 'jwt_token');

    if (token == null) {
      _showErrorSnackBar('Please login first.');
      Navigator.pushNamed(context, '/login');
      return;
    }

    String startStr = DateFormat('yyyy-MM-dd').format(_startDate!);
    String endStr = DateFormat('yyyy-MM-dd').format(_endDate!);

    if (widget.bookingId != null) {
      _handleUpdate(token, startStr, endStr);
    } else {
      _handleNewBooking(token, startStr, endStr);
    }
  }

  void _handleUpdate(String token, String start, String end) async {
    _showLoadingDialog();
     bool success = await ref.read(bookingServiceProvider).updateBookingDate(
      widget.bookingId!,
      start,
      end,
      token,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update Successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      _showErrorSnackBar('Update failed. Check dates availability.');
    }
  }

 void _handleNewBooking(String token, String start, String end) async {
  _showLoadingDialog();
  try {
    final bookingService = ref.read(bookingServiceProvider);
    // استدعاء الخدمة (التي قمنا بتعديلها لتعيد رقم أو نص)
    final result = await bookingService.calculatePrice(
      apartmentId: widget.apartmentId,
      startDate: start,
      endDate: end,
      token: token,
    );

    if (!mounted) return;
    Navigator.pop(context); // إغلاق اللودينج

    if (result is num) {
      // إذا كان رقم، يعني نجح حساب السعر
      _showConfirmationDialog(result.toDouble(), start, end, token);
    } else if (result is String) {
      // إذا كان نص، فهذه هي رسالة الـ Exception من Laravel
      _showErrorSnackBar(result); 
    } else {
      _showErrorSnackBar('Dates unavailable or property ownership issue.');
    }
  } catch (e) {
    if (mounted) Navigator.pop(context);
    _showErrorSnackBar('Server error. Please check your connection.');
  }
}
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showConfirmationDialog(
    double price,
    String start,
    String end,
    String token,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: theme.cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.verified_outlined,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Confirm Reservation',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // عرض الفترة الزمنية بتنسيق نظيف
                  _buildInfoRow(
                    Icons.calendar_month,
                    "Booking Period",
                    "$start ➔ $end",
                    theme,
                  ),
                  const Divider(height: 30, thickness: 0.5),

                  // عرض السعر بشكل بارز
                  _buildInfoRow(
                    Icons.payments_outlined,
                    "Total Amount",
                    "\$${price.toStringAsFixed(2)}",
                    theme,
                    isPrice: true,
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .end, // جعل الأزرار في جهة اليمين لتبدو أرقى
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: theme.hintColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15), // مسافة كافية بين النص والزر
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      minimumSize: const Size(90, 35),
                    ),
onPressed: () async {
  Navigator.pop(dialogContext); // إغلاق دايالوج التأك
  _showLoadingDialog(); // إظهار لودينج

  try {
    bool success = await ref.read(bookingServiceProvider).confirmBooking(
      apartmentId: widget.apartmentId,
      startDate: start,
      endDate: end,
      token: token,
    );

    if (!mounted) return;
    Navigator.pop(context); // إغلاق اللودينج

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation Successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  } catch (e) {
    if (mounted) Navigator.pop(context); 
    _showErrorSnackBar(e.toString().replaceAll('Exception: ', '')); 
  }

                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
    ThemeData theme, {
    bool isPrice = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isPrice ? Colors.green : theme.primaryColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: theme.hintColor, fontSize: 12),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isPrice ? 18 : 14,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.w600,
                  color: isPrice ? Colors.green : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dynamicTitleColor = isDark ? Colors.white : theme.primaryColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/start.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        widget.bookingId == null
                            ? "Select Stay Period"
                            : "Edit Stay Period",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: dynamicTitleColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Minimum reservation period is one month.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 30),
                      DateSelector(
                        title: 'Check-in',
                        date: _startDate,
                        onTap: _selectStartDate,
                      ),
                      const SizedBox(height: 20),
                      DateSelector(
                        title: 'Check-out',
                        date: _endDate,
                        onTap: _selectEndDate,
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        onTap: _submitBooking,
                        textButton: widget.bookingId == null
                            ? 'Confirm Booking'
                            : 'Update Dates',
                        kPrimaryColor: isDark
                            ? Colors.white
                            : theme.primaryColor,
                        vTextColor: isDark ? Colors.black : Colors.white,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
