import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final bool showBorder;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 30.0,
    this.opacity = 0.1,    
    this.padding = const EdgeInsets.all(25.0),
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
Theme.of(context).brightness == Brightness.dark 
    ? Colors.black.withOpacity(0.3) 
    : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: Colors.white.withOpacity(0.2), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}
