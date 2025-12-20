import 'package:flutter/material.dart';
import 'package:ppgc_pro/src/components/property/shimmer.dart';

class PropertyDetailsShimmer extends StatelessWidget {
  const PropertyDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Hero image
            Container(
              height: 240,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Title
                  _line(width: 220, height: 18),
                  const SizedBox(height: 8),
                  _line(width: 140, height: 14),

                  const SizedBox(height: 20),

                  // 🔹 Description header
                  _line(width: 120, height: 16),
                  const SizedBox(height: 12),

                  // 🔹 Description body
                  _line(width: double.infinity),
                  const SizedBox(height: 8),
                  _line(width: double.infinity),
                  const SizedBox(height: 8),
                  _line(width: 260),

                  const SizedBox(height: 20),

                  // 🔹 Property meta
                  Row(
                    children: [
                      _iconBox(),
                      const SizedBox(width: 8),
                      _line(width: 100, height: 12),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _iconBox(),
                      const SizedBox(width: 8),
                      _line(width: 140, height: 12),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Apartment Tour
                  _line(width: 140, height: 16),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, __) {
                        return Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🔹 Action buttons
                  Row(
                    children: [
                      Expanded(child: _button()),
                      const SizedBox(width: 12),
                      Expanded(child: _button()),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== Helpers ==================

  Widget _line({required double width, double height = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _iconBox() {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _button() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
