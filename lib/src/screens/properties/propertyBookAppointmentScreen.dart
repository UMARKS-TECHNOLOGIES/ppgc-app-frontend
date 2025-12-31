import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../store/authProvider.dart';
import '../../store/models/property_models.dart';
import '../../store/property_provider.dart';

class BookInspectionScreen extends HookConsumerWidget {
  final String propertyId;

  const BookInspectionScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final noteController = useTextEditingController();

    final selectedDate = useState<DateTime?>(null);
    final selectedTime = useState<TimeOfDay?>(null);
    final user = ref.watch(currentUserProvider);
    final propertyStatus = ref.watch(propertyStatusProvider);

    Future<void> pickDate() async {
      final now = DateTime.now();
      final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(const Duration(days: 60)),
      );
      if (date != null) selectedDate.value = date;
    }

    Future<void> pickTime() async {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) selectedTime.value = time;
    }

    //  register a listener
    ref.listen(propertyStatusProvider, (previous, next) {
      if (next == PropertyStatus.submittedInspection) {
        context.push(AppRoutes.done, extra: "Inspection booked successfully!");
      }
    });

    void submit() {
      if (propertyStatus == PropertyStatus.submittingInspection) {
        return;
      }
      if (formKey.currentState!.validate() &&
          selectedDate.value != null &&
          selectedTime.value != null) {
        final PropertyInspectionRequest inspectionDetails =
            PropertyInspectionRequest(
              propertyId: propertyId,
              fullName: nameController.text,
              phone: phoneController.text,
              note: noteController.text,
              date: DateFormat.yMMMMd().format(selectedDate.value!),
              time: selectedTime.value!.format(context),
            );
        if (user == null) {
          return;
        }
        ref
            .read(propertyProvider.notifier)
            .propertyBookingInspection(inspectionDetails, user.token);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Inspection'),
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light, // iOS
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 20),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate.value != null
                              ? 'Date: ${DateFormat.yMMMMd().format(selectedDate.value!)}'
                              : 'Pick a Date',
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime.value != null
                              ? 'Time: ${selectedTime.value!.format(context)}'
                              : 'Pick a Time',
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                        const Icon(Icons.access_time, size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes (optional)',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 50),

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.fromColor, AppColors.toColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () => submit(),
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      foregroundColor: const WidgetStatePropertyAll(
                        Colors.white,
                      ),
                    ),
                    child: propertyStatus != PropertyStatus.submittingInspection
                        ? const Text(
                            "Book inspection",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            'Sending! Please hold ',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
