import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/screens/booking/component/popular_booking.dart';
import 'package:ppgc_pro/src/screens/booking/component/room_list_tile.dart';

class BookingScreen extends HookConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: PopularRoomsSection()),
          const SliverToBoxAdapter(child: AvailableRoomsSection()),
        ],
      ),
    );
  }
}
