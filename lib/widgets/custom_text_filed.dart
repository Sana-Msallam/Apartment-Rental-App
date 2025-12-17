import 'package:apartment_rental_app/main.dart';
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);

class CustomTextFiled extends StatefulWidget {
  CustomTextFiled({
    super.key,
    this.hintText,
    this.isPassword,
    this.suffixIconWidget,
    this.vfont,
    this.validator,
    this.controller, //  المتحكم الخارجي
    this.onChanged,
    this.autovalidateMode, //  ضروري لإعادة بناء الـ State في حالة كلمة المرور
  });

  final String? hintText;
  final TextEditingController? controller;
  final bool? isPassword;
  final Widget? suffixIconWidget;
  final String? vfont;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode; //  تعريف الخاصية

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ?? false;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIconWidget != null) {
      return widget.suffixIconWidget;
    } else if (widget.isPassword == true) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: kPrimaryColor,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // الحل الأكيد: قراءة حالة وجود النص مباشرة من المتحكم الخارجي//
    final bool hasText = widget.controller?.text.isNotEmpty ?? false;
    final Color activeColor;

    if (hasText) {
      //  الحالة الثالثة: فيه نص = أزرق غامق ثابت
      activeColor = kPrimaryColor;
    } else {
      //  الحالة الأولى: فاضي وغير مركز عليه = رمادي
      activeColor = vBorderColor;
    }
    return TextFormField(
      controller: widget.controller, //  استخدام المتحكم الخارجي مباشرة
      obscureText: _obscureText,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
      validator: widget.validator,
      // تحديث الـ State عند كل تغيير للنص لإعادة بناء الـ Widget وتطبيق اللون الجديد
      onChanged: (value) {
        // نضمن أن يتم استدعاء onChanged الممرر من الأب إذا كان موجوداً
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        // تحديث الـ State لتغيير لون الحدود بناءً على وجود النص
        setState(() {});
      },    
      decoration: InputDecoration(
        suffixIcon: _buildSuffixIcon(),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: vBorderColor, fontFamily: vfont),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: vBorderColor),
          borderRadius: BorderRadius.circular(5.0),
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: activeColor),
          borderRadius: BorderRadius.circular(5.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
