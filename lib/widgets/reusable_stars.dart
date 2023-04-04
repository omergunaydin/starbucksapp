import 'package:flutter/material.dart';

class ReusableStars extends StatelessWidget {
  double rank;
  bool isSmall;
  ReusableStars({Key? key, required this.rank, required this.isSmall}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: () {
            if (rank >= 0 && rank <= 0.5) {
              return Row(
                children: [
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank > 0.5 && rank < 1) {
              return Row(
                children: [
                  Icon(Icons.star_half, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank >= 1 && rank < 1.5) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank >= 1.5 && rank < 2) {
              return Row(
                children: const [
                  Icon(Icons.star, color: Colors.orange),
                  Icon(Icons.star_half, color: Colors.orange),
                  Icon(Icons.star_border, color: Colors.orange),
                  Icon(Icons.star_border, color: Colors.orange),
                  Icon(Icons.star_border, color: Colors.orange),
                ],
              );
            } else if (rank >= 2 && rank < 2.5) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank >= 2.5 && rank < 3) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_half, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank >= 3 && rank < 3.5) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank >= 3.5 && rank < 4) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_half, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank >= 4 && rank < 4.5) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_border, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank >= 4.5 && rank < 5) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star_half, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            } else if (rank == 5) {
              return Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                  Icon(Icons.star, color: Colors.orange, size: isSmall ? 16 : 24),
                ],
              );
            }
          }(),
        ),
        const SizedBox(width: 10),
        Text(
          rank.toStringAsFixed(1),
          style: isSmall ? textTheme.caption!.copyWith(fontWeight: FontWeight.bold) : textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
