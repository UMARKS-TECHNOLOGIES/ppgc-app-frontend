import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../store/models/property_models.dart';
import '../../store/property_provider.dart';
import '../snackbar_frame.dart';

class PropertySnackListener extends ConsumerWidget {
  const PropertySnackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PropertyState>(propertyProvider, (previous, next) {
      if (next.status == PropertyStatus.error && next.errorMessage != null) {
        AppSnackBar.showError(context, next.errorMessage!);
        ref.read(propertyProvider.notifier).clearPropertyErrors();

      }

      if (next.status == PropertyStatus.loaded &&
          previous?.status == PropertyStatus.loading) {
        AppSnackBar.showSuccess(context, "Properties loaded!");
      }
    });

    return child;
  }
}
