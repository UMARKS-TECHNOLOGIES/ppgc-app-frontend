import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';

import '../components/shared/appBar.dart';
import '../screens/auth/forget_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/new_password_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/password_changed_succes_screen.dart';
import '../screens/auth/register.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/room_details.dart';
import '../screens/booking/summary_screen.dart';
import '../screens/default_screen.dart';
import '../screens/investment/createInvestment1.dart';
import '../screens/investment/createInvestment2.dart';
import '../screens/investment/findInvestment.dart';
import '../screens/investment/investmentPreview.dart';
import '../screens/notification_screen.dart';
import '../screens/onBoarding/onBoarding.dart';
import '../screens/profile/edit_profile.dart';
import '../screens/profile/profileScreen.dart';
import '../screens/properties/home_screen.dart';
import '../screens/properties/propertyBookAppointmentScreen.dart';
import '../screens/properties/singlePropertyScreenWidget.dart';
import '../screens/savings/savings_screen.dart';
import '../screens/successScreen.dart';
import '../screens/terms_and_conditions_screen.dart';
import '../store/authProvider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  final isLoggedIn = ref.watch(isLoggedInProvider);
  final firstLaunchAsync = ref.watch(firstLaunchProvider);
  final authBootstrapAsync = ref.watch(localAuthStatusProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      if (firstLaunchAsync.isLoading ||
          authBootstrapAsync.isLoading ||
          firstLaunchAsync.hasError ||
          authBootstrapAsync.isLoading ||
          authBootstrapAsync.hasError) {
        return null;
      }

      final isFirstLaunch = firstLaunchAsync.value!;

      final location = state.fullPath ?? '';

      final isOnboarding = location == '/onboarding';
      final isPublicAuth = _isPublicAuthRoute(location);

      /// 1️⃣ First launch → onboarding only
      if (isFirstLaunch) {
        return isOnboarding ? null : '/onboarding';
      }

      /// 2️⃣ Logged in → block onboarding & auth
      if (isLoggedIn) {
        if (isOnboarding || location.startsWith('/auth')) {
          return '/home';
        }
        return null;
      }

      /// 3️⃣ NOT logged in → allow public auth routes only
      if (!isLoggedIn) {
        if (isPublicAuth) {
          return null;
        }
        return '/auth/login';
      }

      return null;
    },

    routes: [
      // ShellRoute (protected area)
      ShellRoute(
        builder: (context, state, child) {
          return Consumer(
            builder: (context, ref, _) {
              final user = ref.watch(currentUserProvider);

              final path = state.fullPath ?? '';
              PreferredSizeWidget? appBar;

              if (path.startsWith('/home') && user != null) {
                appBar = buildDynamicAppBar(
                  path: path,
                  context: context,
                  user: user,
                  location: 'Lagos, Nigeria',
                );
              } else if (path.startsWith(AppRoutes.booking)) {
                appBar = customAppBar(
                  title: "Booking",
                  isCenterTitle: false,
                  context: context,
                );
              } else if (path.startsWith(AppRoutes.investment)) {
                appBar = investmentAppBar(path, context);
              } else if (path.startsWith(AppRoutes.saving)) {
                appBar = customAppBar(title: "Savings", context: context);
              } else if (path.startsWith(AppRoutes.profile)) {
                appBar = customAppBar(
                  context: context,
                  title: "Profile",
                  action: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: IconButton(
                        //
                        onPressed: () => authNotifier.logout(),
                        icon: Icon(Icons.logout),
                      ),
                    ),
                  ],
                );
              }

              return DefaultScreen(appBar: appBar, child: child);
            },
          );
        },
        routes: [
          GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
          GoRoute(
            path: '/investment',
            builder: (_, __) => FindInvestmentScreen(onLandBankingTap: () {}),
          ),
          GoRoute(path: '/booking', builder: (_, __) => BookingScreen()),
          GoRoute(path: '/saving', builder: (_, __) => SavingsHomeScreen()),
          GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
        ],
      ),

      // Onboarding
      GoRoute(path: '/onboarding', builder: (_, __) => OnboardingScreen()),

      // Auth (PUBLIC)
      GoRoute(path: '/auth/login', builder: (_, __) => LoginScreen()),

      GoRoute(
        path: '/auth/verify-token',
        builder: (_, state) => OTPVerificationScreen(),
      ),
      GoRoute(
        path: '/auth/new-password',
        builder: (_, state) => NewPassword(email: state.extra as String),
      ),
      GoRoute(
        path: '/auth/password-reset-success',
        builder: (_, __) => PasswordChangedSuccesScreen(),
      ),
      GoRoute(path: '/auth/register', builder: (_, __) => RegisterScreen()),
      GoRoute(path: '/auth/login', builder: (context, state) => LoginScreen()),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpRecovery,
        builder: (context, state) {
          return OTPVerificationScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        builder: (context, state) {
          final email = state.extra as String;
          return NewPassword(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.passwordResetSuccess,
        builder: (context, state) => PasswordChangedSuccesScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => RegisterScreen(),
      ),

      // Terms and Conditions screen route
      GoRoute(
        path: AppRoutes.terms_condition,
        builder: (context, state) {
          final url = state.extra as String;
          return PrivacyPolicyPage(url: url);
        },
      ),
      // Success screen route
      GoRoute(
        path: AppRoutes.done,
        builder: (context, state) {
          final message = state.extra as String;
          return SystemSuccess(message: message);
        },
      ),

      // property routes
      GoRoute(
        path: AppRoutes.singleProperty,
        builder: (context, state) {
          return SinglePropertyScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.inspect_property,
        builder: (context, state) {
          final propertyId = state.extra as String;
          return BookInspectionScreen(propertyId: propertyId);
        },
      ),

      // investment routes
      GoRoute(
        path: '/add-investment',
        builder: (context, state) {
          final category = state.extra as String;
          return LandBankingScreen(onBack: () {}, packageSubtitle: category);
        },
      ),
      GoRoute(
        path: '/add-investment-step2',
        builder: (context, state) {
          return CreateInvestmentScreen();
        },
      ),
      GoRoute(
        path: '/preview-investment',
        builder: (context, state) {
          return PreviewScreen();
        },
      ),

      // Hotel Booking Routes
      GoRoute(
        path: '/booking/room/:id',
        builder: (context, state) {
          return const RoomDetailScreen();
        },
      ),
      GoRoute(
        path: '/booking/review-summary',
        builder: (context, state) => const ReviewSummaryScreen(),
      ),

      // Profile Routes
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => const NotificationScreen(),
      ),
    ],
  );
});

extension BottomTabExtension on BottomTab {
  String get path {
    switch (this) {
      case BottomTab.home:
        return AppRoutes.home;
      case BottomTab.investment:
        return AppRoutes.investment;
      case BottomTab.booking:
        return AppRoutes.booking;
      case BottomTab.saving:
        return AppRoutes.saving;
      case BottomTab.profile:
        return AppRoutes.profile;
    }
  }

  String get title {
    switch (this) {
      case BottomTab.home:
        return 'Home';
      case BottomTab.investment:
        return 'Investments';
      case BottomTab.booking:
        return 'Bookings';
      case BottomTab.saving:
        return 'Savings';
      case BottomTab.profile:
        return 'Profile';
    }
  }

  static BottomTab fromPath(String path) {
    if (path.contains('booking')) return BottomTab.booking;
    if (path.contains('saving')) return BottomTab.saving;
    if (path.contains('home')) return BottomTab.home;
    if (path.contains('profile')) return BottomTab.profile;
    return BottomTab.investment;
  }
}

bool _isPublicAuthRoute(String location) {
  const publicAuthRoutes = {
    '/auth/login',
    '/auth/forgot-password',
    '/auth/verify-token',
    '/auth/new-password',
    '/auth/password-reset-success',
    '/auth/register',
  };

  return publicAuthRoutes.contains(location);
}
