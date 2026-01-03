import 'package:flutter/material.dart';

// نمرر اللون كباراميتر ليكون الـ Widget مستقلاً تماماً
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
    this.primaryColor = const Color(0xFF234F68), // قيمة افتراضية للون
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade600)),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: primaryColor),
          // الـ Style الخاص بالنص المختار في الـ Dropdown
          style: const TextStyle(color: Colors.black, fontSize: 16),
          // تخصيص شكل القائمة المنسدلة نفسها
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(15),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 20, color: primaryColor),
                  const SizedBox(width: 10),
                  Text(item, style: const TextStyle(color: Colors.black)),
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