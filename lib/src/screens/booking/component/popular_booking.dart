import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../components/faildImageFallBack.dart';
import '../../../store/booking_provider.dart';
import '../../../store/models/booking_model.dart';

class PopularRoomCard extends StatelessWidget {
  final HotelRoom room;

  const PopularRoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: NetworkImageFallback(
              imageUrl: room.imageUrl,
              height: 140,
              borderRadius: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            room.roomName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            room.location,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(room.pricePerNight),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(room.rating.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PopularRoomsSection extends ConsumerWidget {
  const PopularRoomsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomProvider);

    final rooms = roomState.rooms.toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Most Popular",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("View all", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) => PopularRoomCard(room: rooms[i]),
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemCount: rooms.length,
          ),
        ),
      ],
    );
  }
}
