import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:apartment_rental_app/widgets/date_selector.dart';
import 'dart:ui'; // ضروري مشان الـ ImageFilter
import 'package:intl/intl.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);
const Color kSecondaryColor = Color(0xFF4B799E);
final String vfont = 'vfo-Regular';

class BookingApp extends StatefulWidget {
  const BookingApp({super.key});

  @override
  State<BookingApp> createState() => _BookingAppState();
}

class _BookingAppState extends State<BookingApp> {
  DateTime? _startDate;
  DateTime? _endDate;

  final DateTime _firstDate = DateTime.now();
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 10));

  // --- اللوجيك الخاص بكِ (بدون أي تغيير) ---
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

  void _submitBooking() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both dates.')),
      );
      return;
    }
    // ... باقي لوجيك الـ Confirm والـ ShowDialog تبعك
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
