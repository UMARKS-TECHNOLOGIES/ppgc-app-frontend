import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:ppgc_pro/src/store/utils/app_constant.dart';

import 'models/property_models.dart';

/// ------------------------------------------------------------------
/// PROPERTY STATE
/// ------------------------------------------------------------------
class PropertyState {
  final Property? property;

  final List<Property> properties;
  final List<Property> popularProperties;

  final PropertyStatus status;
  final String? errorMessage;

  /// Pagination
  final int page;
  final bool isPaginating;
  final bool hasMore;

  const PropertyState({
    this.property,
    this.properties = const [],
    this.popularProperties = const [],
    this.page = 1,
    this.status = PropertyStatus.idle,
    this.errorMessage,
    this.isPaginating = false,
    this.hasMore = true,
  });

  PropertyState copyWith({
    Property? property,
    List<Property>? properties,
    List<Property>? popularProperties,
    PropertyStatus? status,
    String? errorMessage,
    int? page,
    bool? isPaginating,
    bool? hasMore,
  }) {
    return PropertyState(
      property: property ?? this.property,
      properties: properties ?? this.properties,
      popularProperties: popularProperties ?? this.popularProperties,
      status: status ?? this.status,
      errorMessage: errorMessage,
      page: page ?? this.page,
      isPaginating: isPaginating ?? this.isPaginating,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// ------------------------------------------------------------------
/// PROPERTY CONTROLLER
/// ------------------------------------------------------------------
class PropertyController extends StateNotifier<PropertyState> {
  PropertyController() : super(const PropertyState());

  static const int _pageSize = 10;

  /// ---------------------------------------------------------------
  /// FETCH SINGLE PROPERTY
  /// ---------------------------------------------------------------
  Future<void> fetchPropertyById(String id) async {
    state = state.copyWith(status: PropertyStatus.loading);

    final property = state.properties
        .where((p) => p.id == id)
        .cast<Property?>()
        .firstOrNull;

    if (property == null) {
      _setError('Property not found');
      return;
    }

    state = state.copyWith(status: PropertyStatus.loaded, property: property);
  }

  //
  Future<void> propertyBookingInspection(
    PropertyInspectionRequest data,
    String token,
  ) async {
    try {
      state = state.copyWith(status: PropertyStatus.submittingInspection);

      final url = Uri.parse('$PRO_API_BASE_ROUTE/inspections/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "call_number": data.phone,
          "property_id": data.propertyId,
          "date_of_inspection": data.note,
          "time_of_inspection": data.date,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(status: PropertyStatus.submittedInspection);
      } else {
        _setError('Failed to book inspection');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  //

  /// ---------------------------------------------------------------
  /// INITIAL FETCH / REFRESH PROPERTIES
  /// ---------------------------------------------------------------
  Future<void> refreshProperties() async {
    state = state.copyWith(
      properties: [],
      page: 1,
      hasMore: true,
      status: PropertyStatus.loading,
      errorMessage: null,
    );

    await fetchNextPage();
  }

  /// ---------------------------------------------------------------
  /// FETCH NEXT PAGE (PAGINATION)
  /// ---------------------------------------------------------------
  Future<void> fetchNextPage({int pageSize = _pageSize}) async {
    if (state.isPaginating || !state.hasMore) return;

    try {
      state = state.copyWith(isPaginating: true, errorMessage: null);

      final url = Uri.parse('$PRO_API_BASE_ROUTE/properties').replace(
        queryParameters: {
          'page': state.page.toString(),
          'size': pageSize.toString(),
        },
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        final fetched = data.map((item) => Property.fromJson(item)).toList();

        state = state.copyWith(
          properties: [...state.properties, ...fetched],
          page: state.page + 1,
          hasMore: fetched.length == pageSize,
          isPaginating: false,
          status: PropertyStatus.loaded,
        );
      } else {
        _setError('Failed to fetch properties');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// ---------------------------------------------------------------
  /// FETCH POPULAR PROPERTIES (NO PAGINATION)
  /// ---------------------------------------------------------------
  Future<void> fetchPopularProperties() async {
    try {
      final url = Uri.parse(
        '$PRO_API_BASE_ROUTE/properties',
      ).replace(queryParameters: {'popular': 'true'});

      if (kDebugMode) {
        print('Fetching popular properties: $url');
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        final popular = data.map((item) => Property.fromJson(item)).toList();

        state = state.copyWith(popularProperties: popular);
      } else {
        _setError('Failed to fetch popular properties');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// ---------------------------------------------------------------
  /// UTILITIES
  /// ---------------------------------------------------------------
  void clearProperty() {
    state = const PropertyState();
  }

  void clearErrors() {
    state = state.copyWith(status: PropertyStatus.idle, errorMessage: null);
  }

  void _setError(String message) {
    state = state.copyWith(
      status: PropertyStatus.error,
      errorMessage: message,
      isPaginating: false,
    );
  }
}

/// ------------------------------------------------------------------
/// PROVIDER
/// ------------------------------------------------------------------
final propertyProvider =
    StateNotifierProvider<PropertyController, PropertyState>(
      (ref) => PropertyController(),
    );

final popularPropertiesProvider = Provider<List<Property?>>((ref) {
  return ref.watch(propertyProvider.select((p) => p.popularProperties));
});

final propertyStatusProvider = Provider<PropertyStatus>((ref) {
  return ref.watch(propertyProvider.select((p) => p.status));
});
