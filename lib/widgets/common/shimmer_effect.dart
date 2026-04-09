import 'package:flutter/material.dart';
class ShimmerEffect extends StatelessWidget {
  final double width; final double height; final BorderRadius? borderRadius;
  const ShimmerEffect({super.key, required this.width, required this.height, this.borderRadius});
  @override Widget build(BuildContext context) => Container(width: width, height: height, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: borderRadius ?? BorderRadius.circular(8)));
}
