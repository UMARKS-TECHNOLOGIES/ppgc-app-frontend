const AppUser testUser = AppUser(
  id: "12",
  email: "dummy@example.com",
  token: "dummy_token_123",
  firstName: "John",
  lastName: "Doe",
);
final testUserProfile = Profile(
  nin: "1234567890",
  firstName: "John",
  lastName: "Doe",
  id: '',
  email: "testuser@example.com",
  emailVerified: true,
  userRole: "admin",
  createdAt: DateTime.parse("2025-12-11T13:19:46.548Z"),
  dateOfBirth: DateTime.parse("1995-06-15"),
  phoneNumber: "+2348012345678",
  address: "123 Test Street, Lagos, Nigeria",
  emailNotification: true,
  pushNotification: true,
  gender: "male",
  profileAvatar: const ProfileAvatar(
    publicId: "avatar_123",
    secureUrl:
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400',
  ),
  accessToken: "dummy_access_token_123",
);

/// ----- Auth State -----
enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  error,
  //  for registration
  sendingEmail,
  verifyingEmail,
  emailSent,
  emailVerificationFailed,
  verified,

  //
}

class AppUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  const AppUser({
    required this.id,
    required this.email,
    required this.token,
    required this.firstName,
    required this.lastName,
  });

  /// Parse from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'].toString(),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      token: json['access_token'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'token': token,
    };
  }
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// PROFILE MODEL
// ______________________________________________________________
class Profile {
  final String id;
  final String email;
  final String nin;
  final String firstName;
  final String lastName;
  final bool emailVerified;
  final String userRole;
  final DateTime createdAt;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final String address;
  final bool emailNotification;
  final bool pushNotification;
  final String gender;
  final ProfileAvatar profileAvatar;
  final String accessToken;

  const Profile({
    required this.nin,
    required this.firstName,
    required this.lastName,

    required this.id,
    required this.email,
    required this.emailVerified,
    required this.userRole,
    required this.createdAt,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.address,
    required this.emailNotification,
    required this.pushNotification,
    required this.gender,
    required this.profileAvatar,
    required this.accessToken,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(dynamic value, DateTime fallback) {
      if (value == null) return fallback;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return fallback;
      }
    }

    return Profile(
      nin: json['nin'] ?? "".toString(),
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      id: json['id'].toString(),
      email: json['email'] as String? ?? '',
      emailVerified: json['email_verified'] as bool? ?? false,
      userRole: json['user_role'] as String? ?? '',
      createdAt: _parseDate(json['created_at'], DateTime.now()),
      dateOfBirth: _parseDate(json['date_of_birth'], DateTime(1970, 1, 1)),
      phoneNumber: json['phone_number'] as String? ?? '',
      address: json['address'] as String? ?? '',
      emailNotification: json['email_notification'] as bool? ?? false,
      pushNotification: json['push_notification'] as bool? ?? false,
      gender: json['gender'] as String? ?? '',
      profileAvatar: json['profile_avatar'] is Map<String, dynamic>
          ? ProfileAvatar.fromJson(json['profile_avatar'])
          : ProfileAvatar(publicId: '', secureUrl: ''),
      accessToken: json['access_token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'email_verified': emailVerified,
      'user_role': userRole,
      'created_at': createdAt.toIso8601String(),
      'date_of_birth': dateOfBirth.toIso8601String(),
      'phone_number': phoneNumber,
      'address': address,
      'email_notification': emailNotification,
      'push_notification': pushNotification,
      'gender': gender,
      'profile_avatar': profileAvatar.toJson(),
      'access_token': accessToken,
    };
  }
}

class ProfileAvatar {
  final String publicId;
  final String secureUrl;

  const ProfileAvatar({required this.publicId, required this.secureUrl});

  factory ProfileAvatar.fromJson(Map<String, dynamic> json) {
    return ProfileAvatar(
      publicId: json['public_id'],
      secureUrl: json['secure_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'secure_url': secureUrl};
  }
}

class PreReg {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const PreReg({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
  factory PreReg.fromJson(Map<String, dynamic> json) {
    return PreReg(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
  }
}
