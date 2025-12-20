import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/store/authProvider.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../components/shared/Textinput.dart' as MyTextInput;
import '../../store/models/user_models.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final theme = Theme.of(context); // Access the theme

    final isFilled = useState(false);

    useEffect(
      () {
        void listener() {
          isFilled.value =
              emailController.text.isNotEmpty &&
              firstNameController.text.isNotEmpty &&
              passwordController.text.isNotEmpty &&
              lastNameController.text.isNotEmpty;
        }

        emailController.addListener(listener);
        lastNameController.addListener(listener);
        firstNameController.addListener(listener);
        passwordController.addListener(listener);

        return () {
          emailController.removeListener(listener);
          lastNameController.removeListener(listener);
          firstNameController.removeListener(listener);
          passwordController.removeListener(listener);
        };
      },
      [
        emailController,
        firstNameController,
        lastNameController,
        passwordController,
      ],
    );
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.sendingEmail;
    final canSubmit = isFilled.value && !isLoading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.status != AuthStatus.emailSent &&
          next.status == AuthStatus.emailSent) {
        context.push('/auth/verify-token');
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness:
              Brightness.dark, // makes icons visible on dark background
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            children: [
              Image.asset(
                'assets/auth/reg_header.png', // Replace with your image asset
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 30,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: const Text("Hi", style: TextStyle(fontSize: 18)),
                      ),
                      Center(
                        child: const Text(
                          "Welcome",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyTextInput.TextInput(
                        controller: emailController,
                        title: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      MyTextInput.TextInput(
                        controller: firstNameController,
                        title: "First Name",
                      ),
                      MyTextInput.TextInput(
                        controller: lastNameController,
                        title: "Last Name",
                        keyboardType: TextInputType.text,
                      ),
                      MyTextInput.TextInput(
                        controller: passwordController,
                        title: "Password",
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      if (authState.status ==
                          AuthStatus.emailVerificationFailed)
                        Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 10),
                          child: Text(
                            authState.errorMessage ??
                                'Oop! something went, Please try again',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black, // default text color
                            fontSize: 12,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  "By selecting ‘Agree and sign up’, I agree to the ",
                            ),
                            TextSpan(
                              text: "PPGC Terms ",
                              style: const TextStyle(color: Colors.blue),
                              // Optionally make it tappable:
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle PPGC Terms tap
                                },
                            ),
                            const TextSpan(text: "and "),
                            TextSpan(
                              text: "Services Agreement. ",
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Services Agreement tap
                                },
                            ),
                            const TextSpan(
                              text:
                                  "Find out more about how we use and protect your data in our ",
                            ),
                            TextSpan(
                              text: "Privacy Policy.",
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Privacy Policy tap
                                },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: canSubmit
                            ? () {
                                ref
                                    .read(authProvider.notifier)
                                    .verifyEmail(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      firstNameController.text.trim(),
                                      lastNameController.text.trim(),
                                    );
                              }
                            : null,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: canSubmit
                                ? const LinearGradient(
                                    colors: [
                                      AppColors.fromColor,
                                      AppColors.toColor,
                                    ],
                                  )
                                : null,
                            color: canSubmit ? null : AppColors.grayColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Agree and Sign up',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Center(
                        child: Text("Or", style: theme.textTheme.bodyMedium),
                      ),
                      const SizedBox(height: 20),

                      SocialAuth(logo: "assets/auth/apple.png", title: "Apple"),
                      const SizedBox(height: 15),

                      SocialAuth(
                        logo: "assets/auth/google.png",
                        title: "Google",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialAuth extends StatelessWidget {
  const SocialAuth({super.key, required this.logo, required this.title});
  final String logo;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: title == "Google"
            ? WidgetStatePropertyAll(AppColors.lightGrayColor)
            : WidgetStatePropertyAll(Colors.black),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(logo, height: 40),
          SizedBox(width: 8),
          Text(
            ("Continue with $title"),
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
