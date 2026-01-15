   
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);

class CustomTextFiled extends StatefulWidget {
  const CustomTextFiled({
    super.key,
    this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIconWidget,
    this.controller,
    this.validator,
    this.onChanged,
    this.autovalidateMode,
    this.keyboardType,
  });

  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIconWidget;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    widget.controller?.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color contentColor = isDark ? Colors.white : kPrimaryColor;
    final Color hintColor = isDark ? Colors.white70 : vBorderColor;
    
    final Color fieldFillColor = isDark ? Colors.white.withOpacity(0.1) : Colors.white;

    final bool hasText = widget.controller?.text.isNotEmpty ?? false;
    
    final Color activeColor = hasText ? contentColor : (isDark ? Colors.white38 : vBorderColor);

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      
      style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black),
      
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldFillColor, 
        hintText: widget.hintText,
        hintStyle: TextStyle(color: hintColor), 
        
        prefixIcon: widget.prefixIcon != null 
            ? Icon(widget.prefixIcon, color: contentColor) 
            : null,
            
        suffixIcon: widget.isPassword
            ? IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility, 
                  color: contentColor
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : widget.suffixIconWidget,

        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: activeColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: contentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}