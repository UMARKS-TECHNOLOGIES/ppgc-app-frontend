int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is num) return value.toInt();

  if (value is String) {
    return int.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}

String _asString(dynamic value) => value == null ? '' : value.toString();

double _asDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value is num) return value.toDouble();
  return defaultValue;
}

String _formatPrice(dynamic value) {
  if (value is num) return value.toString();
  return '0';
}

bool? _asBoolNullable(dynamic value) {
  if (value is bool) return value;
  return null;
}

class HotelRoom {
  final String id;
  final String imageUrl;
  final List<String> otherImages;
  final String roomName;
  final String hotelName;
  final String location;
  final String pricePerNight;
  final double rating;
  final String description;
  final List<String> amenities;
  final int bedCount;
  final int maxOccupancy;
  final bool? isPopular; // null-safe as requested

  const HotelRoom({
    required this.id,
    required this.imageUrl,

    required this.roomName,
    required this.hotelName,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.isPopular,
    required this.description,
    required this.amenities,
    required this.bedCount,
    required this.maxOccupancy,
    required this.otherImages,
  });

  /// 🔐 Defensive JSON parser aligned to actual API
  factory HotelRoom.fromJson(Map<String, dynamic> json) {
    return HotelRoom(
      id: _asString(json['id']),
      imageUrl: _asString(json['cover_image']?['secure_url']),
      roomName: _asString(json['room_number']),
      description: _asString(json['description']),
      hotelName: _asString(json['hotel_id']),
      location: _asString(json['status']),
      bedCount: _asInt(json['bed_count']),
      pricePerNight: _formatPrice(json['price_per_night']),
      rating: json['available'] == true ? 1.0 : 0.0,
      amenities: List<String>.from(json['amenities'] ?? []),
      otherImages:
          (json['other_images'] as List<dynamic>?)
              ?.map((e) => e['secure_url'] as String)
              .toList() ??
          [],
      maxOccupancy: _asInt(json['max_occupancy']),
      isPopular: _asBoolNullable(json['is_popular']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'room_name': roomName,
      'hotel_name': hotelName,
      'location': location,
      'price_per_night': pricePerNight,
      'rating': rating,
      'is_popular': isPopular,
      'description': description,
      'amenities': amenities,
      'bed_count': bedCount,
      'max_occupancy': maxOccupancy,
      'other_images': otherImages,
    };
  }
}

enum RoomStatus { idle, loading, loaded, error }

class Review {
  final String name;
  final double rating;
  final String userImage;

  const Review({
    required this.name,
    required this.rating,
    required this.userImage,
  });
}
