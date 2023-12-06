import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  ShimmerBlock({
    super.key,
    required this.width,
    required this.height,
  });
  @override
  Color getByTimeColor() {
    // Get the current time
    final currentTime = DateTime.now();
    // Determine the background color based on the hour
    if (currentTime.hour >= 18 || currentTime.hour < 5) {
      return Color.fromRGBO(58, 58, 58, 1); // For late hours
    } else {
      return Color.fromRGBO(214, 214, 214, 1); // Default color
    }
  }

  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Shimmer.fromColors(
          baseColor: getByTimeColor(),
          highlightColor: Color.fromRGBO(177, 177, 177, 1),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Color.fromARGB(125, 92, 92, 92),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
