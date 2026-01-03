import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:apartment_rental_app/widgets/date_selector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class BookingApp extends StatefulWidget {
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
  State<BookingApp> createState() => _BookingAppState();
}

class _BookingAppState extends State<BookingApp> {
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
    final DateTime minRequiredEndDate = DateTime(_startDate!.year, _startDate!.month + 1, _startDate!.day);
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate != null && _endDate!.isAfter(minRequiredEndDate) ? _endDate! : minRequiredEndDate,
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
            ? theme.colorScheme.copyWith(primary: Colors.white, surface: const Color(0xFF22282A))
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

    const storage = FlutterSecureStorage();
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
    bool success = await BookingService().updateBookingDate(widget.bookingId!, start, end, token);
    
    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Successful!'), backgroundColor: Colors.green));
      Navigator.pop(context, true); 
    } else {
      _showErrorSnackBar('Update failed. Check dates availability.');
    }
  }

  void _handleNewBooking(String token, String start, String end) async {
    _showLoadingDialog();
    try {
      double? totalPrice = await BookingService().calculatePrice(
        apartmentId: widget.apartmentId,
        startDate: start,
        endDate: end,
        token: token,
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (totalPrice != null) {
        _showConfirmationDialog(totalPrice, start, end, token);
      } else {
        _showErrorSnackBar('Dates might be unavailable.');
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorSnackBar('Server error.');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void _showConfirmationDialog(double price, String start, String end, String token) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text('Confirm Reservation', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: Icon(Icons.calendar_today, color: theme.primaryColor), 
                title: const Text("Period"), 
                subtitle: Text("$start to $end", style: theme.textTheme.bodyMedium)),
            ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.green), 
                title: const Text("Total"), 
                subtitle: Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text("Cancel", style: TextStyle(color: theme.hintColor))),
          CustomButton(
            textButton: 'Confirm',
            onTap: () async {
              Navigator.pop(dialogContext);
              _showLoadingDialog();
              bool success = await BookingService().confirmBooking(
                apartmentId: widget.apartmentId,
                startDate: start,
                endDate: end,
                token: token,
              );
              if (mounted) Navigator.pop(context); 
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservation Successful!'), backgroundColor: Colors.green));
                Navigator.pop(context);
              }
            },
            kPrimaryColor: theme.primaryColor, vTextColor: Colors.white, width: 100,
          ),
        ],
      ),
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
          Positioned.fill(child: Image.asset('assets/images/start.png', fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
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
                        widget.bookingId == null ? "Select Stay Period" : "Edit Stay Period",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: dynamicTitleColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Minimum reservation period is one month.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 30),
                      DateSelector(title: 'Check-in', date: _startDate, onTap: _selectStartDate),
                      const SizedBox(height: 20),
                      DateSelector(title: 'Check-out', date: _endDate, onTap: _selectEndDate),
                      const SizedBox(height: 40),
                      CustomButton(
                        onTap: _submitBooking,
                        textButton: widget.bookingId == null ? 'Confirm Booking' : 'Update Dates',
                        kPrimaryColor: isDark ? Colors.white : theme.primaryColor,
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