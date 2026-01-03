import 'package:apartment_rental_app/models/user_model.dart';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:apartment_rental_app/widgets/date_selector.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);
const Color kSecondaryColor = Color(0xFF4B799E);
final String vfont = 'vfo-Regular';

class BookingApp extends StatefulWidget {
  final UserModel user;
  final int apartmentId;

  const BookingApp({super.key, required this.user,required this.apartmentId,});

  @override
  State<BookingApp> createState() => _BookingAppState();
}

class _BookingAppState extends State<BookingApp> {
  DateTime? _startDate;
  DateTime? _endDate;

  final DateTime _firstDate = DateTime.now();
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 10));

  Future<void> _selectStartDate() async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _startDate ?? _firstDate,
        firstDate: _firstDate,
        lastDate: _lastDate,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: kPrimaryColor),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the start date first.')),
      );
      return;
    }
    final DateTime minRequiredEndDate = DateTime(
      _startDate!.year,
      _startDate!.month + 1,
      _startDate!.day,
    );
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _endDate != null && _endDate!.isAfter(minRequiredEndDate)
            ? _endDate!
            : minRequiredEndDate,
        firstDate: minRequiredEndDate,
        lastDate: _lastDate,
        builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: kPrimaryColor),
          ),
          child: child!,
        ),
      );
      if (picked != null) setState(() => _endDate = picked);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _submitBooking() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both dates.')),
      );
      return;
    }
    String startStr = DateFormat('yyyy-MM-dd').format(_startDate!);
    String endStr = DateFormat('yyyy-MM-dd').format(_endDate!);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    double? totalPrice = await ApiService().calculatePrice(
     apartmentId: widget.apartmentId, // هنا نستخدم الـ ID الحقيقي
      startDate: startStr,
      endDate: endStr
    );
    Navigator.pop(context);
    if (totalPrice != null) {
      _showConfirmationDialog(totalPrice, startStr, endStr);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to calculate price. Try again.')),
      );
    }
  }

  void _showConfirmationDialog(double price, String start, String end) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Confirm Reservation',
          style: TextStyle(color: kPrimaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today, color: kSecondaryColor),
              title: const Text("Period"),
              subtitle: Text("$start to $end"),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.green),
              title: const Text("Total Price"),
              subtitle: Text(
                "\$${price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        actions: [
          Row(
            // استخدمنا Row مشان يطلعوا الزرين جنب بعض بشكل مرتب
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  textButton: 'Confirm',
                  vTextColor: Colors.white,
                  kPrimaryColor: kPrimaryColor,
                  width: null, // خليه ياخد مساحة الـ Expanded
                  onTap: () async {
                    // إظهار لودينغ بسيط أثناء التأكيد النهائي
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    bool success = await ApiService().confirmBooking(
                    apartmentId: widget.apartmentId, // الـ ID الحقيقي للشقة
                      startDate: start,
                      endDate: end,
                      totalPrice: price,
                      userId:
                          widget.user.id!, // widget.user.id, // مؤقتاً لحين تمرير اليوزر الحقيقي كما شرحت فوق
                    );

                    Navigator.pop(context); // إغلاق اللودينغ
                    Navigator.pop(context); // إغلاق الدايلوج

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Booking Successful!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 1. الخلفية
          Positioned.fill(
            child: Image.asset('assets/images/start.png', fit: BoxFit.cover),
          ),

          // 2. المحتوى باستخدام GlassContainer
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassContainer(
                // هنا الفرق! يمكنك إضافة قيم هنا للتحكم بالشكل (انظري الشرح بالأسفل)
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Icon(
                    //   Icons.calendar_today_rounded,
                    //   size: 60,
                    //   color: kPrimaryColor,
                    // ),
                    const SizedBox(height: 15),
                    const Text(
                      "Select Stay Period",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Minimum reservation period is one month.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color.fromARGB(255, 44, 44, 44)),
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
                      textButton: 'Confirm Booking',
                      vTextColor: Colors.white,
                      kPrimaryColor: kPrimaryColor,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
