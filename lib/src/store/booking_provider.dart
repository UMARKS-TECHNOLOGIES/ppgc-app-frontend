import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:ppgc_pro/src/store/utils/api_route.dart';

import 'models/booking_model.dart';

const List<HotelRoom> roomsDummyData = [
  HotelRoom(
    id: 'room_001',
    imageUrl:
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
    roomName: 'Deluxe King Room',
    hotelName: '12 Kings Hotel',
    location: 'GRA Phase 2, Port Harcourt',
    pricePerNight: '₦45,000 / Night',
    rating: 4.7,
    isPopular: true,
  ),
  HotelRoom(
    id: 'room_002',
    imageUrl:
        'https://images.unsplash.com/photo-1560067174-894d6b2faa48?auto=format&fit=crop&w=800&q=80',
    roomName: 'Executive Suite',
    hotelName: '12 Kings Hotel',
    location: 'GRA Phase 2, Port Harcourt',
    pricePerNight: '₦65,000 / Night',
    rating: 4.9,
    isPopular: true,
  ),
  HotelRoom(
    id: 'room_003',
    imageUrl:
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=80',
    roomName: 'Standard Double Room',
    hotelName: 'Emerald Lodge',
    location: 'Ada George, Port Harcourt',
    pricePerNight: '₦30,000 / Night',
    rating: 4.2,
  ),
  HotelRoom(
    id: 'room_004',
    imageUrl:
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80',
    roomName: 'Classic Single Room',
    hotelName: 'Emerald Lodge',
    location: 'Ada George, Port Harcourt',
    pricePerNight: '₦25,000 / Night',
    rating: 4.0,
  ),
];

class RoomState {
  // Single room (detail view)
  final HotelRoom? room;
  // Room list
  final List<HotelRoom> rooms;
  // State & error
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

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // FETCH SINGLE ROOM (DETAIL PAGE)
  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
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

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // FETCH ALL AVAILABLE ROOMS
  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> fetchAvailableRooms({int page = 1, int size = 10}) async {
    if (state.isPaginating || !state.hasMore) return;

    try {
      final isFirstPage = page == 1;

      state = state.copyWith(
        status: isFirstPage ? RoomStatus.loading : state.status,
        isPaginating: !isFirstPage,
        errorMessage: null,
      );

      final url = Uri.parse('$PRO_API_BASE_ROUTE/rooms').replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'available': 'true',
        },
      );

      if (kDebugMode) {
        print(url);
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<HotelRoom> fetchedRooms = (data as List)
            .map((json) => HotelRoom.fromJson(json))
            .toList();

        state = state.copyWith(
          rooms: isFirstPage ? fetchedRooms : [...state.rooms, ...fetchedRooms],
          page: page,
          hasMore: fetchedRooms.length == size,
          isPaginating: false,
          status: RoomStatus.loaded,
        );
      } else {
        state = state.copyWith(
          status: RoomStatus.error,
          isPaginating: false,
          errorMessage: 'Failed to fetch rooms (${response.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: RoomStatus.error,
        isPaginating: false,
        errorMessage: e.toString(),
      );
    }
  }

  // dummy api test

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // STATE CLEANUP
  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
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
