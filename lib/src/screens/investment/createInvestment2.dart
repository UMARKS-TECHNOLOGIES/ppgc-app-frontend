import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/routeConstant.dart';
import '../../utils/themeData.dart';
import 'component/input.dart';

class CreateInvestmentScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> package;

  const CreateInvestmentScreen({
    super.key,
    required this.onBack,
    required this.package,
  });

  @override
  State<CreateInvestmentScreen> createState() => _CreateInvestmentScreenState();
}

class _CreateInvestmentScreenState extends State<CreateInvestmentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _amountController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: widget.onBack,
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Create Investment'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    widget.package["plan"] == "2"
                        ? "Monthly Plan"
                        : widget.package["plan"] == "10"
                        ? "Quarterly Plan"
                        : widget.package["plan"] == "15"
                        ? "Half yearly Plan"
                        : "Yearly Plan",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.package["plan"] == "2"
                        ? "30 days(2% ROI)"
                        : widget.package["plan"] == "10"
                        ? "90 days (10% ROI)"
                        : widget.package["plan"] == "15"
                        ? "6 month (15% ROI)"
                        : "1 year (30% ROI)",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 30),

                  CustomInputField(
                    label: "Investment amount (₦)",
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    prefixText: "₦ ",
                  ),

                  const SizedBox(height: 20),

                  CustomInputField(
                    label: "Give this investment plan a name (optional)",
                    controller: _nameController,
                    hintText: "Please enter",
                  ),

                  const SizedBox(height: 40),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    context.push(
                      AppRoutes.previewInvestment,
                      extra: widget.package,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Important for gradient
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.fromColor, AppColors.toColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
