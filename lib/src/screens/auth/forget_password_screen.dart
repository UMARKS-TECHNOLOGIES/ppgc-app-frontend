import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../components/shared/Textinput.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final theme = Theme.of(context);

    final isFilled = useState(false);

    useEffect(() {
      void listener() {
        isFilled.value = emailController.text.isNotEmpty;
      }

      emailController.addListener(listener);
      return () => emailController.removeListener(listener);
    }, [emailController]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),

        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Forgot Pin",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: const Text(
                        "We’ll send you a code via email to reset your pin",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextInput(controller: emailController, title: "Email"),
                    const SizedBox(height: 25),
                    const Spacer(),

                    // request password reset button
                    GestureDetector(
                      onTap: () {
                        // TODO: Handle submit
                        context.push(
                          AppRoutes.otpRecovery,
                          extra: emailController.text,
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: isFilled.value
                              ? LinearGradient(
                                  colors: [
                                    AppColors.fromColor,
                                    AppColors.toColor,
                                  ],
                                )
                              : null,
                          color: isFilled.value ? null : AppColors.grayColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
