import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:ppgc_pro/src/store/utils/app_constant.dart';

import 'models/booking_model.dart';

const List<HotelRoom> roomsDummyData = [
  // HotelRoom(
  //   id: 'room_001',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
  //   roomName: 'Deluxe King Room',
  //   hotelName: '12 Kings Hotel',
  //   location: 'GRA Phase 2, Port Harcourt',
  //   pricePerNight: '₦45,000 / Night',
  //   rating: 4.7,
  //   isPopular: true,
  // ),
  // HotelRoom(
  //   id: 'room_002',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1560067174-894d6b2faa48?auto=format&fit=crop&w=800&q=80',
  //   roomName: 'Executive Suite',
  //   hotelName: '12 Kings Hotel',
  //   location: 'GRA Phase 2, Port Harcourt',
  //   pricePerNight: '₦65,000 / Night',
  //   rating: 4.9,
  //   isPopular: true,
  // ),
  // HotelRoom(
  //   id: 'room_003',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=80',
  //   roomName: 'Standard Double Room',
  //   hotelName: 'Emerald Lodge',
  //   location: 'Ada George, Port Harcourt',
  //   pricePerNight: '₦30,000 / Night',
  //   rating: 4.2,
  // ),
  // HotelRoom(
  //   id: 'room_004',
  //   imageUrl:
  //       'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80',
  //   roomName: 'Classic Single Room',
  //   hotelName: 'Emerald Lodge',
  //   location: 'Ada George, Port Harcourt',
  //   pricePerNight: '₦25,000 / Night',
  //   rating: 4.0,
  // ),
];

class RoomState {
  final HotelRoom? room;
  final List<HotelRoom> rooms;
  final RoomStatus status;
  final String? errorMessage;
  // Pagination support (optional but future-proof)
  final int page;
  final bool isPaginating;
  final bool hasMore;
  const RoomState({
    this.room,
    this.rooms = roomsDummyData,
    this.status = RoomStatus.idle,
    this.errorMessage,
    this.page = 0,
    this.isPaginating = false,
    this.hasMore = true,
  });

  RoomState copyWith({
    HotelRoom? room,
    List<HotelRoom>? rooms,
    RoomStatus? status,
    String? errorMessage,
    int? page,
    bool? isPaginating,
    bool? hasMore,
  }) {
    return RoomState(
      room: room ?? this.room,
      rooms: rooms ?? this.rooms,
      status: status ?? this.status,
      errorMessage: errorMessage,
      page: page ?? this.page,
      isPaginating: isPaginating ?? this.isPaginating,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class RoomController extends StateNotifier<RoomState> {
  RoomController() : super(RoomState());

  // Private
  Future<void> _fetchPage({required int page, required int size}) async {
    try {
      final url = Uri.parse('$PRO_API_BASE_ROUTE/hotel/rooms/available/all')
          .replace(
            queryParameters: {
              'page': page.toString(),
              'size': size.toString(),
              'available': 'true',
            },
          );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final fetchedRooms = data
            .map((json) => HotelRoom.fromJson(json))
            .toList();

        state = state.copyWith(
          rooms: [...state.rooms, ...fetchedRooms],
          page: page,
          hasMore: fetchedRooms.length == size,
          isPaginating: false,
          status: RoomStatus.loaded,
        );
      } else {
        throw Exception('Failed (${response.statusCode})');
      }
    } catch (e) {
      state = state.copyWith(
        isPaginating: false,
        status: RoomStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchRoomById(String id) async {
    try {
      state = state.copyWith(status: RoomStatus.loading);

      final url = Uri.parse('$PRO_API_BASE_ROUTE/rooms/$id/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final room = HotelRoom.fromJson(data);

        state = state.copyWith(room: room, status: RoomStatus.loaded);
      } else {
        state = state.copyWith(
          status: RoomStatus.error,
          errorMessage: 'Failed to fetch room (${response.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: RoomStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchAvailableRooms({int size = 10}) async {
    if (state.status == RoomStatus.loading) return;

    try {
      state = state.copyWith(
        status: RoomStatus.loading,
        errorMessage: null,
        page: 0,
        hasMore: true,
        rooms: [],
      );

      await _fetchPage(page: 1, size: size);
    } catch (e) {
      state = state.copyWith(
        status: RoomStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchMore({int size = 10}) async {
    if (state.isPaginating || !state.hasMore) return;

    final nextPage = state.page + 1;

    state = state.copyWith(isPaginating: true);

    await _fetchPage(page: nextPage, size: size);
  }

  void clearRoom() {
    state = const RoomState();
  }

  void clearErrors() {
    state = state.copyWith(status: RoomStatus.idle, errorMessage: null);
  }
}

final roomProvider = StateNotifierProvider<RoomController, RoomState>(
  (ref) => RoomController(),
);

final selectedRoomProvider = Provider<HotelRoom?>((ref) {
  return ref.watch(roomProvider.select((s) => s.room));
});

final roomActionsProvider = Provider<RoomController>((ref) {
  return ref.read(roomProvider.notifier);
});
