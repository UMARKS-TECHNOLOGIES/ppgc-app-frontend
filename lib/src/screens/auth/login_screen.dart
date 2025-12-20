import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:ppgc_pro/src/store/authProvider.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../components/shared/Textinput.dart';
import '../../components/shared/appBar.dart';
import '../../store/models/user_models.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final pinController = useTextEditingController();
    final theme = Theme.of(context);

    final isFormValid = useState(false);

    // -----------------------------
    // Form validation listener
    // -----------------------------
    useEffect(() {
      final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
        r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
        r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
      );

      void listener() {
        final email = emailController.text.trim();
        final pin = pinController.text.trim();

        isFormValid.value =
            email.isNotEmpty && pin.isNotEmpty && emailRegex.hasMatch(email);
      }

      emailController.addListener(listener);
      pinController.addListener(listener);

      return () {
        emailController.removeListener(listener);
        pinController.removeListener(listener);
      };
    }, [emailController, pinController]);

    final authState = ref.watch(authProvider);

    // -----------------------------
    // Auth side-effects
    // -----------------------------
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(AppRoutes.home);
      }

      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,

            content: Text(
              next.errorMessage ?? 'Login failed',
              style: TextStyle(fontSize: 13),
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: customAppBar(context: context, title: ''),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              Center(child: Text("Hi", style: theme.textTheme.bodyLarge)),
              Center(
                child: Text(
                  "Welcome",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              TextInput(controller: emailController, title: "Email"),

              const SizedBox(height: 12),

              TextInput(
                controller: pinController,
                title: "Password",
                obscureText: true,
                keyboardType: TextInputType.text,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (authState.loginError != null &&
                      authState.status != AuthStatus.authenticating)
                    Text(
                      style: TextStyle(color: Colors.redAccent, fontSize: 13),
                      authState.loginError.toString(),
                      softWrap: true,
                      maxLines: null,
                      textAlign: TextAlign.start,
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.push(AppRoutes.forgotPassword);
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // -----------------------------
              // Login Button
              // -----------------------------
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid.value
                      ? () {
                          ref
                              .read(authProvider.notifier)
                              .login(
                                emailController.text.trim(),
                                pinController.text.trim(),
                              );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: AppColors.grayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: isFormValid.value
                          ? LinearGradient(
                              colors: [AppColors.fromColor, AppColors.toColor],
                            )
                          : null,
                      color: isFormValid.value ? null : AppColors.grayColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: authState.status == AuthStatus.authenticating
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(child: Text("Or", style: theme.textTheme.bodyMedium)),

              const SizedBox(height: 20),

              const SocialAuth(logo: "assets/auth/apple.png", title: "Apple"),

              const SizedBox(height: 15),

              const SocialAuth(logo: "assets/auth/google.png", title: "Google"),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  context.push(AppRoutes.register);
                },
                child: const Text("Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Social Auth Button
// --------------------------------------------------
class SocialAuth extends StatelessWidget {
  const SocialAuth({super.key, required this.logo, required this.title});

  final String logo;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: title == "Google"
            ? AppColors.lightGrayColor
            : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(logo, height: 36),
          const SizedBox(width: 10),
          Text(
            "Continue with $title",
            style: TextStyle(
              color: title == "Google" ? Colors.black54 : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
