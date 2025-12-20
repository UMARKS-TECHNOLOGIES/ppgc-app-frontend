/// String-based route constants
class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const investment = '/investment';
  static const booking = '/booking';
  static const saving = '/saving';
  static const profile = '/profile';

  //   Authentication
  static const otpRecovery = '/auth/otp-token';
  static const newPassword = '/auth/new-password';
  static const passwordResetSuccess = '/auth/done-reset';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';

  static const terms_condition = '/service/terms-and-conditions';

  // system
  static const done = "/success";
  static const error = "/error";

  // Propertes Routes
  static const singleProperty = "/single-property";
  static const inspect_property = "/inspect-property";

  //   Investment Routes
  static const add = "/add-investment";
  static const add2 = "/add-investment-step2";
  static const previewInvestment = "/preview-investment";

  //   Booking Routes
  static final singleRoom = (id) {
    return "/booking/room/${id}";
  };

  static final reviewSummary = "/booking/review-summary";

  static final editProfile = "/profile/edit-profile";
  static final notification = "/notification";
}

/// Optional enum for navigation tabs
enum BottomTab { home, investment, booking, saving, profile }
