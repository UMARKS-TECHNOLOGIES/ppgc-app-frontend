import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/routeConstant.dart';
import '../../store/investment_provider.dart';
import '../../utils/themeData.dart';
import 'component/input.dart';

class CreateInvestmentScreen extends ConsumerStatefulWidget {
  const CreateInvestmentScreen({super.key});

  @override
  ConsumerState<CreateInvestmentScreen> createState() =>
      _CreateInvestmentScreenState();
}

class _CreateInvestmentScreenState
    extends ConsumerState<CreateInvestmentScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _nameController;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    final draft = ref.read(investmentProvider).draft;

    _amountController = TextEditingController(
      text: (draft.amount != null && draft.amount! > 0)
          ? draft.amount.toString()
          : '',
    );

    _nameController = TextEditingController(text: draft.name ?? '');

    _amountController.addListener(_validateForm);
    _validateForm();
  }

  void _validateForm() {
    final amount = int.tryParse(_amountController.text.trim());
    setState(() {
      _isFormValid = amount != null && amount > 0;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    FocusScope.of(context).unfocus();

    ref
        .read(investmentProvider.notifier)
        .updateDraft(
          amount: int.parse(_amountController.text.trim()),
          name: _nameController.text.trim(),
        );

    context.push(AppRoutes.previewInvestment);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(investmentProvider).draft;

    final String planTitle;
    final String planSubtitle;

    switch (draft.percentage?.toString()) {
      case "2":
        planTitle = "Monthly Plan";
        planSubtitle = "30 days (2% ROI)";
        break;
      case "10":
        planTitle = "Quarterly Plan";
        planSubtitle = "90 days (10% ROI)";
        break;
      case "15":
        planTitle = "Half yearly Plan";
        planSubtitle = "6 months (15% ROI)";
        break;
      default:
        planTitle = "Yearly Plan";
        planSubtitle = "1 year (30% ROI)";
    }

    return Scaffold(
      appBar: AppBar(
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
                    planTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    planSubtitle,
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
                  onPressed: _isFormValid ? _onNext : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
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
