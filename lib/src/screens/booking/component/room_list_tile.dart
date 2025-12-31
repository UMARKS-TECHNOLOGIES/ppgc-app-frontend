import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../../components/faildImageFallBack.dart';
import '../../../routes/routeConstant.dart';
import '../../../store/booking_provider.dart';
import '../../../store/models/booking_model.dart';

class RoomListTile extends StatelessWidget {
  final HotelRoom room;
  final VoidCallback onTap;

  const RoomListTile({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.grey.withValues(alpha: 0.15),
        highlightColor: Colors.grey.withValues(alpha: 0.05),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              NetworkImageFallback(
                imageUrl: room.imageUrl,
                height: 80,
                width: 80,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room.location,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(room.pricePerNight),
                        const Spacer(),
                        Icon(Icons.star, size: 14, color: AppColors.fromColor),
                        const SizedBox(width: 4),
                        Text(room.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvailableRoomsSection extends ConsumerWidget {
  const AvailableRoomsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomProvider);
    final roomNotifier = ref.read(roomProvider.notifier);

    final rooms = roomState.rooms;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available Rooms",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          for (int i = 0; i < rooms.length; i++) ...[
            RoomListTile(
              room: rooms[i],
              onTap: () {
                roomNotifier.fetchRoomById(id: rooms[i].id);
                context.push(AppRoutes.singleRoom(rooms[i].id));
              },
            ),

            // 🔹 Trigger pagination near the end
            if (i == rooms.length - 1 &&
                roomState.hasMore &&
                !roomState.isPaginating)
              Builder(
                builder: (_) {
                  Future.microtask(() {
                    roomNotifier.fetchMore();
                  });
                  return const SizedBox.shrink();
                },
              ),
          ],

          // 🔹 Pagination loader
          if (roomState.isPaginating)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
