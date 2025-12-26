import 'package:flutter/material.dart';

class NetworkImageFallback extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const NetworkImageFallback({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) : borderRadius =
           borderRadius ?? const BorderRadius.all(Radius.circular(16));

  bool get _hasValidUrl => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: _hasValidUrl
          ? Image.network(
              imageUrl!,
              height: height,
              width: width,
              fit: fit,
              loadingBuilder: _loadingBuilder,
              errorBuilder: _errorBuilder,
            )
          : _fallback(),
    );
  }

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return _fallback();
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return _fallback();
  }

  Widget _fallback() {
    return _FallbackContainer(height: height, width: width);
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
