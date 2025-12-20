/// Enum for async state handling
enum PropertyStatus { idle, loading, loaded, error }

/// Submodel for property area/location
///
///

class OtherImages {
  final String secureUrl;
  final String publicId;

  const OtherImages({required this.secureUrl, required this.publicId});

  /// JSON → Model
  factory OtherImages.fromJson(Map<String, dynamic> json) {
    return OtherImages(
      secureUrl: json['secureUrl'] ?? '',
      publicId: json['public_id'] ?? '',
    );
  }

  /// Model → JSON (optional but recommended)
  Map<String, dynamic> toJson() {
    return {'secureUrl': secureUrl, 'public_id': publicId};
  }
}

class PropertyArea {
  final String country;
  final String stateOrProvince;
  final String cityOrTown;
  final String county;
  final String street;
  final String zipOrPostalCode;
  final String buildingNameOrSuite;

  PropertyArea({
    required this.country,
    required this.stateOrProvince,
    required this.cityOrTown,
    required this.county,
    required this.street,
    required this.zipOrPostalCode,
    required this.buildingNameOrSuite,
  });

  factory PropertyArea.fromJson(Map<String, dynamic> json) {
    return PropertyArea(
      country: json['country'] ?? '',
      stateOrProvince: json['state_or_province'] ?? '',
      cityOrTown: json['city_or_town'] ?? '',
      county: json['county'] ?? '',
      street: json['street'] ?? '',
      zipOrPostalCode: json['zip_or_postal_code'] ?? '',
      buildingNameOrSuite: json['building_name_or_suite'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'state_or_province': stateOrProvince,
      'city_or_town': cityOrTown,
      'county': county,
      'street': street,
      'zip_or_postal_code': zipOrPostalCode,
      'building_name_or_suite': buildingNameOrSuite,
    };
  }
}

/// Property Model
class Property {
  final String id;
  final String title;
  final String price;
  final String description;
  final String availability;
  final String type;
  final String coverImageUrl; // main image
  final List<OtherImages> otherImages; // additional images
  final List<String> features;
  final PropertyArea area; // location details
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.availability,
    required this.type,
    required this.coverImageUrl,
    required this.otherImages,
    required this.features,
    required this.area,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to parse API JSON
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      // Use .toString() to handle if ID is sent as a number (int)
      id: json['id']?.toString() ?? '',

      // Use 'as String?' and '??' to handle nulls safely
      title: json['title'] as String? ?? 'No Title',

      // Price is often a number in DBs, so use toString()
      price: json['price']?.toString() ?? '0',

      description: json['description'] as String? ?? '',
      availability: json['availability'] as String? ?? '',
      type: json['type'] as String? ?? '',

      // Safely access nested object to prevent crash if cover_image is null
      coverImageUrl: (json['cover_image'] != null)
          ? (json['cover_image']['secure_url'] as String? ?? '')
          : '',

      otherImages:
          (json['other_images'] as List<dynamic>?)
              ?.map((img) => OtherImages.fromJson(img as Map<String, dynamic>))
              .toList() ??
          [],

      // Safely map features
      features:
          (json['features'] as List<dynamic>?)
              ?.map((f) => f.toString())
              .toList() ??
          [],

      // Handle null area
      area: json['area'] != null
          ? PropertyArea.fromJson(json['area'] as Map<String, dynamic>)
          : PropertyArea(
              // Provide default empty if missing
              country: '',
              stateOrProvince: '',
              cityOrTown: '',
              county: '',
              street: '',
              zipOrPostalCode: '',
              buildingNameOrSuite: '',
            ),

      createdAt: DateTime.parse(
        json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'availability': availability,
      'type': type,
      'cover_image': {'secure_url': coverImageUrl},
      'other_images': otherImages.map((url) => {'secure_url': url}).toList(),
      'features': features,
      'area': area,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
