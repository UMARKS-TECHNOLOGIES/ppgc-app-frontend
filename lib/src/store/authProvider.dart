import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:ppgc_pro/src/store/utility_provider.dart';
import 'package:ppgc_pro/src/store/utils/app_constant.dart';
import 'package:ppgc_pro/src/store/utils/secure_storage.dart';
import 'package:ppgc_pro/src/store/utils/shared_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_models.dart';

class AuthState {
  final AppUser? user;
  final Profile? userProfile;
  final AuthStatus status;
  final String? errorMessage;
  final String? loginError;
  final PreReg? preReg;

  const AuthState({
    this.user,
    required this.preReg,
    this.userProfile,
    this.status = AuthStatus.unauthenticated,
    this.errorMessage,
    this.loginError,
  });

  const AuthState.initial()
    : user = null,
      preReg = const PreReg(
        firstName: '',
        lastName: '',
        email: '',
        password: '',
      ),
      userProfile = null,
      status = AuthStatus.unauthenticated,
      errorMessage = null,
      loginError = null;

  factory AuthState.test() {
    return AuthState(
      user: testUser,
      preReg: const PreReg(
        firstName: '',
        lastName: '',
        email: '',
        password: '',
      ),
      userProfile: testUserProfile,
      status: AuthStatus.authenticated,
    );
  }

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    AppUser? user,
    PreReg? preReg,
    Profile? userProfile,
    AuthStatus? status,
    String? errorMessage,
    String? loginError,
  }) {
    return AuthState(
      user: user ?? this.user,
      userProfile: userProfile ?? this.userProfile,
      status: status ?? this.status,

      errorMessage: errorMessage ?? this.errorMessage,
      loginError: loginError ?? this.loginError,
      preReg: preReg ?? this.preReg,
    );
  }
}

/// ----- Auth Controller -----
class AuthController extends StateNotifier<AuthState> {
  final Ref ref;

  AuthController(this.ref) : super(AuthState.initial());

  /// Called after fresh login OR app restart
  void restoreSession({required AppUser user}) {
    state = state.copyWith(
      user: user,
      status: AuthStatus.authenticated,
      errorMessage: null,
    );
  }

  /// Called when local session is invalid
  void clearSession() {
    state = AuthState.initial();
  }

  // Register

  // Forgot Password
  Future<void> forgotPassword(String email) async {}

  // Reset Password

  //

  /// Mock Profile calls
  Future<void> fetchProfile() async {
    state = state.copyWith(status: AuthStatus.loadingProfile);
    final uri = Uri.parse('$PRO_API_BASE_ROUTE/settings/');

    final connectivity = ref.read(connectivityProvider);

    if (connectivity.connection == ConnectivityStatus.disconnected) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "No internet connection",
      );
      return;
    }
    try {
      http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer ${state.user?.token ?? ""}",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        state = state.copyWith(
          status: AuthStatus.profileLoaded,
          errorMessage: null,
          userProfile: Profile.fromJson(json),
        );
      } else if (response.statusCode >= 300 && response.statusCode < 500) {
        final decoded = jsonDecode(response.body);
        final message = decoded is Map && decoded['detail'] != null
            ? decoded['detail']
            : 'Failed loading profile';
        state = state.copyWith(
          status: AuthStatus.profileError,
          errorMessage: message,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.profileError,
          errorMessage: "Something went wrong",
        );
      }
    } catch (e) {
      print(e.toString());

      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Logout
  void logout() async {
    state = const AuthState.initial();
    await StorageService().clearAll();
  }

  /// Get current user
  AppUser? getUser() {
    return state.user;
  }

  /// Validate token
  bool validateToken() {
    final user = state.user;
    if (user == null) return false;
    // Example: token validation logic
    return user.token.isNotEmpty; // Replace with real validation
  }

  // Verify Email
  Future<void> verifyEmail({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.sendingEmail);
    final uri = Uri.parse(
      '$PRO_API_BASE_ROUTE/auth/request-email-verification-code/',
    );

    try {
      http.Response response = await http.post(
        uri,

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, "first_name": firstName}),
      );

      if (response.statusCode == 200) {
        //   navigate to otp verification screen
        state = state.copyWith(
          status: AuthStatus.emailSent,
          preReg: PreReg.fromJson({
            'email': email,
            'first_name': firstName,
            'last_name': lastName,
            'password': password,
          }),
          errorMessage: null,
        );
      } else if (response.statusCode >= 300 && response.statusCode < 500) {
        final decoded = jsonDecode(response.body);
        final message = decoded is Map && decoded['detail'] != null
            ? decoded['detail']
            : 'Authentication failed';
        state = state.copyWith(
          status: AuthStatus.emailVerificationFailed,
          errorMessage: message,
        );
      } else {
        final decoded = jsonDecode(response.body);
        final message = decoded is Map && decoded['detail'] != null
            ? decoded['detail']
            : 'Something went wrong! Please try again.';

        state = state.copyWith(
          status: AuthStatus.emailVerificationFailed,
          errorMessage: message,
        );
      }
    } catch (e) {
      final message = 'Something went wrong! Please try again.';

      state = state.copyWith(
        status: AuthStatus.emailVerificationFailed,
        errorMessage: message,
      );
    }
  }

  // Verify OTP
  Future<void> verifyOTP({required String otp, required PreReg regData}) async {
    state = state.copyWith(status: AuthStatus.verifyingEmail);
    final uri = Uri.parse(
      '$PRO_API_BASE_ROUTE/auth/confirm-email-verification-code/',
    );

    try {
      http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          ...regData.toJson(),
          'code': otp,
          // Un comment  below  to send the app token to the server
          // "appFcmToken": FCMService.getToken(),
        }),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(status: AuthStatus.verified, errorMessage: null);
        //  navigate to login screen
      }
    } catch (e) {
      final message = 'Something went wrong! Please try again.';

      state = state.copyWith(
        status: AuthStatus.emailVerificationFailed,
        errorMessage: message,
      );
    }
  }

  Future<void> login(String email, String password) async {
    final uri = Uri.parse('$PRO_API_BASE_ROUTE/auth/signin/');

    try {
      state = state.copyWith(status: AuthStatus.authenticating);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email, 'password': password,
          // Un comment  below  to send the app token to the server
          // "appFcmToken": FCMService.getToken()
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;

        // Adapt this to your actual API response shape
        final user = AppUser.fromJson(decoded);
        final userProfile = Profile.fromJson(decoded);

        await StorageService().saveUserToken(user.token);
        await LocalStorageService.setObject(
          appUserKeyConstant,
          user.toLocalStateJson(),
        );

        state = state.copyWith(
          user: user,
          userProfile: userProfile,
          status: AuthStatus.authenticated,
          errorMessage: null,
        );
      } else if (response.statusCode >= 300 && response.statusCode < 500) {
        final decoded = jsonDecode(response.body);
        final message = decoded is Map && decoded['detail'] != null
            ? decoded['detail']
            : 'Authentication failed';

        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: message,
          loginError: message,
        );
      } else {
        state = state.copyWith(
          errorMessage: "Something went wrong",
          status: AuthStatus.error,
        );
      }
    } catch (e) {
      print(e.toString());
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

/// ----- Provider -----
final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);

final userProfileProvider = Provider<Profile?>((ref) {
  return ref.watch(authProvider.select((state) => state.userProfile));
});
final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authProvider.select((s) => s.status));
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authProvider.select((s) => s.user));
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((s) => s.isLoggedIn));
});

final firstLaunchProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isFirstLaunch') ?? true;
});

final localAuthStatusProvider = FutureProvider<AuthStatus>((ref) async {
  final storage = StorageService();
  final authNotifier = ref.read(authProvider.notifier);

  final token = await storage.getUserToken();

  if (token != null) {
    final userJson = await LocalStorageService.getObject(appUserKeyConstant);

    if (userJson != null) {
      final AppUser user = AppUser(
        id: userJson["id"],
        email: userJson["email"],
        token: token,
        firstName: userJson["firstName"] ?? "",
        lastName: userJson["lastName"] ?? "",
      );

      // 🔁 Restore session into memory
      authNotifier.restoreSession(user: user);

      return AuthStatus.authenticated;
    }
  }

  // 🚪 No valid local session
  authNotifier.clearSession();
  return AuthStatus.unauthenticated;
});
