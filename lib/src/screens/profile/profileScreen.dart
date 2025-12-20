import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/components/shared/btnsWidgets.dart';

import '../../routes/routeConstant.dart';
import '../../store/authProvider.dart';
import 'ProfileImagePicker.dart';

// Colors
const Color kPrimaryBlack = Color(0xFF1A1A1A);
const Color kSecondaryGrey = Color(0xFF828282);
const Color kBgWhite = Colors.white;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    print(profile);

    // Defensive UI: profile not yet loaded
    if (profile == null) {
      return const Scaffold(
        backgroundColor: kBgWhite,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: kBgWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Profile Image
            buildProfileAvatar(profileImage: profile.profileAvatar.secureUrl),

            const SizedBox(height: 40),

            _ProfileDetailRow(
              label: "Full Name",
              value: "${profile.firstName} ${profile.lastName}",
            ),
            _ProfileDetailRow(
              label: "Phone Number",
              value: profile.phoneNumber ?? "—",
            ),
            _ProfileDetailRow(label: "Gender", value: profile.gender ?? "—"),
            _ProfileDetailRow(label: "Email", value: profile.email),

            /// Address (wrap-safe)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Address",
                    style: TextStyle(color: kSecondaryGrey, fontSize: 14),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      profile.address ?? "—",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: kPrimaryBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _ProfileDetailRow(label: "NIN", value: profile.nin ?? "—"),

            const SizedBox(height: 40),

            BTNWidget(
              title: "Edit Profile",
              onPressed: () => context.push(AppRoutes.editProfile),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for a single row of profile details
class _ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: kSecondaryGrey, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: kPrimaryBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
