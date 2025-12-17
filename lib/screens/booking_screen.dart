import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:apartment_rental_app/widgets/date_selector.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);
const Color kSecondaryColor = Color(0xFF4B799E);
const Color kShadowColor = Color(0x20000000);
final String vfont = 'vfo-Regular';

class BookingApp extends StatefulWidget {
  BookingApp({super.key});

  @override
  State<BookingApp> createState() => _BookingAppState();
}

class _BookingAppState extends State<BookingApp> {
  DateTime? _startDate;
  DateTime? _endDate; // التاريخ الذي ينتهي فيه الحجز

  final DateTime _firstDate = DateTime.now();
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365 * 10));

  Future<void> _selectStartDate() async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _startDate ?? _firstDate,
        firstDate:
            _firstDate,
        lastDate: _lastDate,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: kPrimaryColor,
              colorScheme: ColorScheme.light(primary: kPrimaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
      print('Failed to show DatePicker for Start Date: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to show DatePicker for Start Date:$e')),
      );
    }
  }

  // دالة لاختيار تاريخ الانتهاء (Check-out)
  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select the start date first.',
            style: TextStyle(
              fontSize: 20,
              fontFamily: vfont,
              color: Colors.white,
            ),
          ),
        ),
      );
      return;
    }

    // نستخدم إضافة شهر لتطبيق قيد الحجز الشهري
    final DateTime minRequiredEndDate = DateTime(
      _startDate!.year,
      _startDate!.month + 1, // إضافة شهر واحد
      _startDate!.day,
    );
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        // initialDate: يجب أن يكون إما التاريخ القديم أو الحد الأدنى المطلوب
        initialDate: _endDate != null && _endDate!.isAfter(minRequiredEndDate)
            ? _endDate!
            : minRequiredEndDate,
        // القيد الأساسي: لا يمكن اختيار تاريخ قبل شهر من البدء
        firstDate: minRequiredEndDate,
        lastDate: _lastDate,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: kPrimaryColor,
              colorScheme: ColorScheme.light(primary: kPrimaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        setState(() {
          _endDate = picked;
        });
      }
    } catch (e) {
      // طباعة أي خطأ غير متوقع
      print('Failed to show DatePicker for End Date: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred trying to open the calendar:$e',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: kPrimaryColor,
            ),
          ),
        ),
      );
    }
  }

  // دالة لتنفيذ عملية الحجز
  void _submitBooking() {
    // 1. التحقق من أن التواريخ مُحددة باستخدام Guard Clause
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select both the start and end dates.',
            style: TextStyle(
              fontSize: 22,
              fontFamily: vfont,
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return; // يمنع استمرار تنفيذ الكود إذا كان أحد التواريخ فارغاً
    }

    // 2. التحقق من الحد الأدنى للحجز الشهري
    final minRequiredEndDate = DateTime(
      _startDate!.year,
      _startDate!.month + 1,
      _startDate!.day,
    );
    if (_endDate!.isBefore(minRequiredEndDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
            'Minimum reservation period is one month.',
            style: TextStyle(
              fontSize: 22,
              fontFamily: vfont,
              color: vBorderColor,
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    //  تنسيق التواريخ (آمن الآن لأننا تحققنا أنها ليست null)
    final String formattedStart = DateFormat('dd-MM-yyyy').format(_startDate!);

    final String formattedEnd = DateFormat('dd-MM-yyyy').format(_endDate!);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Booking Confirmed',
          style: TextStyle(
            fontSize: 25,
            fontFamily: vfont,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
        content: Text(
          'The apartment is reserved from:\n$formattedStart\n To \n$formattedEnd',
          style: TextStyle(
            fontSize: 23,
            fontFamily: vfont,
            fontWeight: FontWeight.w400,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Select Booking Period',
          style: TextStyle(fontFamily: vfont, color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Please select the required stay period:',
              style: TextStyle(
                fontSize: 20,
                fontFamily: vfont,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 30),

            DateSelector(
              title: 'Check-in',
              date: _startDate,
              onTap: () => _selectStartDate(),
            ),

            const SizedBox(height: 20),

            DateSelector(
              title: 'Check-out',
              date: _endDate,
              onTap: () => _selectEndDate(),
            ),

            const SizedBox(height: 40),

            CustomButton(
              onPressed: () => _submitBooking(),
              textButton: 'Confirm Booking',
              vTextColor: const Color(0xFFFFFFFF),
              kPrimaryColor: kPrimaryColor,
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            if (_startDate != null && _endDate != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Reservation: ${DateFormat('dd/MM/yyyy').format(_startDate!)} to ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
