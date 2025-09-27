import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [],
        stops: [0.1, 0.5, 0.9],
      ),
      child: GridView.builder(
        itemCount: 6, // Replace with the actual item count
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          // Generate the shimmer cells using a Builder
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[300],
              );
            },
          );
        },
      ),
    );
  }
}
