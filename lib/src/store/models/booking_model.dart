class HotelRoom {
  final String id;
  final String imageUrl;
  final String roomName;
  final String hotelName;
  final String location;
  final String pricePerNight;
  final double rating;
  final bool isPopular;

  const HotelRoom({
    required this.id,
    required this.imageUrl,
    required this.roomName,
    required this.hotelName,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    this.isPopular = false,
  });

  /// 🔐 Defensive JSON parser
  factory HotelRoom.fromJson(Map<String, dynamic> json) {
    return HotelRoom(
      id: _asString(json['id']),
      imageUrl: _asString(
        json['image_url'] ?? json['image'] ?? json['thumbnail'],
      ),
      roomName: _asString(json['room_name'] ?? json['name']),
      hotelName: _asString(json['hotel_name'] ?? json['hotel']),
      location: _asString(json['location']),
      pricePerNight: _formatPrice(json['price_per_night'] ?? json['price']),
      rating: _asDouble(json['rating'], defaultValue: 0.0),
      isPopular: _asBool(json['is_popular']),
    );
  }

  /// Optional but recommended
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
    };
  }

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // SAFE TYPE CONVERTERS
  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  static String _asString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  static double _asDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? defaultValue;
  }

  static bool _asBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    return value.toString().toLowerCase() == 'true';
  }

  static String _formatPrice(dynamic value) {
    if (value == null) return '';

    if (value is num) {
      return '₦${value.toStringAsFixed(0)} / Night';
    }

    final parsed = double.tryParse(value.toString());
    if (parsed != null) {
      return '₦${parsed.toStringAsFixed(0)} / Night';
    }

    return value.toString();
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
