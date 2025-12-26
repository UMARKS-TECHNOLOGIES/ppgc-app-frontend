import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../store/authProvider.dart';
import '../../store/models/user_models.dart'; // Your custom colors

class OTPVerificationScreen extends HookConsumerWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preReg = ref.watch(authProvider).preReg;
    final otpController = useTextEditingController();
    final isCompleted = useState(false);
    final data = ref.watch(authProvider).preReg;
    final email = data?.email ?? '';

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.status != AuthStatus.emailSent &&
          next.status == AuthStatus.verified) {
        context.push('/auth/login');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
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
                    Text(
                      "An email with a verification code was sent to this email ",

                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      controller: otpController,
                      autoFocus: true,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      cursorColor: AppColors.blueColor,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 4),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 45,
                        activeColor: AppColors.blueColor,
                        selectedColor: AppColors.blueColor,
                        inactiveColor: Colors.grey.shade400,
                      ),
                      onChanged: (value) {
                        isCompleted.value = value.length == 4;
                      },
                    ),

                    const SizedBox(height: 25),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: Resend OTP logic here
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Didn’t get a code?"),
                          SizedBox(width: 5),
                          const Text(
                            "0:58",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: isCompleted.value
                          ? () {
                              ref
                                  .read(authProvider.notifier)
                                  .verifyOTP(
                                    otp: otpController.text,
                                    regData: PreReg(
                                      email: preReg!.email,
                                      firstName: preReg.firstName,
                                      lastName: preReg.lastName,
                                      password: preReg.password,
                                    ),
                                  );
                            }
                          : null,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: isCompleted.value
                              ? LinearGradient(
                                  colors: [
                                    AppColors.fromColor,
                                    AppColors.toColor,
                                  ],
                                )
                              : null,
                          color: isCompleted.value ? null : AppColors.grayColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Verify',
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
