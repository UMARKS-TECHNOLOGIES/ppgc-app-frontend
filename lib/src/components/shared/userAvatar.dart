import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imgUrl;
  final double radius;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    required this.imgUrl,
    this.radius = 24.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey[300],
      child: ClipOval(
        // ClipOval ensures the image stays circular
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: _buildImageContent(),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    // 1. Handle Null or Empty URL immediately
    if (imgUrl == null || imgUrl!.isEmpty) {
      return _buildFallbackIcon();
    }

    // 2. Use CachedNetworkImage to manage the state (Loading -> Error/Success)
    return CachedNetworkImage(
      imageUrl: imgUrl!,
      fit: BoxFit.cover,

      // A. LOADING STATE: Shows spinner
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: radius, // Spinner size proportional to avatar
          height: radius,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),

      // B. ERROR STATE: Catches 400/404/Offline and shows Icon
      errorWidget: (context, url, error) {
        // This explicitly replaces the spinner with the icon
        return _buildFallbackIcon();
      },
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(
      Icons.person,
      size: radius, // Icon size proportional to avatar
      color: Colors.grey[600],
    );
  }
}
