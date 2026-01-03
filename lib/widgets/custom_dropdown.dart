import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final IconData icon;
  final Color primaryColor;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
    this.primaryColor = const Color(0xFF234F68),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint, 
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600)
          ),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white : primaryColor),
          
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16),
          
          dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 20, color: isDark ? Colors.white : primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    item, 
                    style: TextStyle(color: isDark ? Colors.white : Colors.black)
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}