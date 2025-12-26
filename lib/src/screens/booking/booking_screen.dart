import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/screens/booking/component/popular_booking.dart';
import 'package:ppgc_pro/src/screens/booking/component/room_list_tile.dart';

import '../../store/booking_provider.dart';
import '../../store/models/booking_model.dart';
import 'booking_shimmer.dart';

class BookingScreen extends HookConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomProvider);
    final roomController = ref.read(roomProvider.notifier);

    // 🔹 Fetch first page once
    useEffect(() {
      Future.microtask(() {
        if (roomState.rooms.isEmpty) {
          roomController.fetchAvailableRooms();
        }
      });
      return null;
    }, const []);

    ref.listen(roomProvider, (previous, next) {
      if (next.status == RoomStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,

            content: Text(
              next.errorMessage ?? 'Oops! sorry something went wrong',
              style: TextStyle(fontSize: 13),
            ),
          ),
        );
      }
    });

    return roomState.status == RoomStatus.loading
        ? BookingShimmer()
        : SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: PopularRoomsSection()),
                const SliverToBoxAdapter(child: AvailableRoomsSection()),
              ],
            ),
          );
  }
}
