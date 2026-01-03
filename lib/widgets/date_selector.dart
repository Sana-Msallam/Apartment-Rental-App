import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);

const Color kSecondaryColor = Color(0xFF4B799E);
const Color kShadowColor = Color(0x20000000);
final String vfont = 'vfo-Regular';

class DateSelector extends StatelessWidget {
  DateSelector({required this.date, this.title, required this.onTap});

  final String? title; 
  final DateTime? date; 
  final VoidCallback onTap; 

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
      
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.white24 : vBorderColor.withOpacity(0.5), 
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : kSecondaryColor,
                      fontFamily: vfont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date == null
                        ? 'Select Date'
                        : DateFormat('EEEE, MMM d, yyyy').format(date!),
                    style: TextStyle(
                      fontSize: 18,
                      color: date == null 
                          ? Colors.grey 
                          : (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.calendar_today, 
                color: isDark ? Colors.white : kPrimaryColor, 
                size: 30
              ),
            ],
          ),
        ),
      ),
    );
  }
}