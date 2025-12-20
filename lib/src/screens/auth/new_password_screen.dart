import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart'; // assuming go_router is used
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../components/shared/Textinput.dart';

class NewPassword extends HookConsumerWidget {
  final String email;

  const NewPassword({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstPasswordController = useTextEditingController();
    final secondPasswordController = useTextEditingController();
    final theme = Theme.of(context); // Access the theme

    final isFilled = useState(false);

    useEffect(() {
      void listener() {
        isFilled.value =
            firstPasswordController.text.isNotEmpty &&
            firstPasswordController.text.isNotEmpty;
      }

      secondPasswordController.addListener(listener);
      firstPasswordController.addListener(listener);

      return () {
        firstPasswordController.removeListener(listener);
        secondPasswordController.removeListener(listener);
      };
    }, [secondPasswordController, firstPasswordController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: BackButton(onPressed: () => context.go("/home")),
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
                      "Create new PIN",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "Reset your PIN by creating a new one",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 20),
                    TextInput(
                      controller: firstPasswordController,
                      title: "Pin",
                    ),
                    TextInput(
                      controller: secondPasswordController,
                      title: "Pin",
                    ),
                    Text(
                      "Password doesn't match",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 25),
                    Spacer(),

                    GestureDetector(
                      onTap: isFilled.value
                          ? () {
                              // ref
                              //     .read(authProvider.notifier)
                              //     .login(
                              //       firstPasswordController.text,
                              //       secondPasswordController.text,
                              //     );
                              context.go(AppRoutes.passwordResetSuccess);
                            }
                          : null,
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
                    SizedBox(height: 40),
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
