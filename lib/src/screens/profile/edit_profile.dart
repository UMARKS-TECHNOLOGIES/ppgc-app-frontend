import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../store/authProvider.dart';
import '../../store/models/user_models.dart';
import 'ProfileImagePicker.dart';

// Define the colors based on the design pattern
const Color kPrimaryBlack = Color(0xFF1A1A1A);
const Color kSecondaryGrey = Color(0xFF828282);
const Color kYellowColor = Color(0xFFEED202);
const Color kBgWhite = Colors.white;
const Color kBorderGrey = Color(0xFFE0E0E0);

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  String _selectedGender = "Female";
  bool _initialized = false;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    /// ✅ LISTEN ONCE – CORRECT PLACE
    ref.listenManual<Profile?>(userProfileProvider, (previous, next) {
      if (next != null && !_initialized) {
        _populateFields(next);
        _initialized = true;
        setState(() {});
      }
    });
  }

  /// Populate form controllers ONCE from state
  void _populateFields(Profile profile) {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _phoneController.text = profile.phoneNumber;
    _addressController.text = profile.address;
    _addressController.text = profile.address;
    _selectedGender = profile.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: kBgWhite,
      resizeToAvoidBottomInset: false,
      drawerScrimColor: kBgWhite,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: const Text("Profile Update"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// Avatar (already state-aware)
                  buildProfileAvatar(
                    profileImage: profile.profileAvatar.secureUrl,
                  ),

                  const SizedBox(height: 30),

                  _spacer(),
                  _buildLabel("First name"),
                  _buildTextField(controller: _firstNameController),

                  _spacer(),
                  _buildLabel("Last name"),
                  _buildTextField(controller: _lastNameController),

                  _spacer(),
                  _buildLabel("Gender"),
                  _buildGenderDropdown(),

                  _spacer(),
                  _buildLabel("Phone number"),
                  _buildTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  _spacer(),
                  _buildLabel("Address"),
                  _buildTextField(controller: _addressController),

                  const SizedBox(height: 40),

                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  // ---------------- UI helpers ----------------

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: kBorderGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          items: const [
            "Female",
            "Male",
          ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedGender = value);
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // 🔜 dispatch update payload to AuthController
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Profile Saved")));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kYellowColor,
          foregroundColor: kPrimaryBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Save",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: kPrimaryBlack,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kYellowColor, width: 2),
      ),
    ),
  );

  Widget _spacer() => const SizedBox(height: 20);
}
