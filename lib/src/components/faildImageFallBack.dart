import 'package:flutter/material.dart';

class NetworkImageFallback extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit fit;

  const NetworkImageFallback({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return _FallbackContainer(height: height, width: width);
        },
        errorBuilder: (context, error, stackTrace) {
          return _FallbackContainer(height: height, width: width);
        },
      ),
    );
  }
}

class _FallbackContainer extends StatelessWidget {
  final double height;
  final double width;

  const _FallbackContainer({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, color: Colors.grey.shade600, size: 36),
    );
  }
}
