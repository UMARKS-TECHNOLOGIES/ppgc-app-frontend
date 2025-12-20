import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:ppgc_pro/src/store/utils/api_route.dart';

import 'models/property_models.dart';

/// State for a single property
class PropertyState {
  final Property? property;
  final PropertyStatus status;
  final String? errorMessage;

  final List<Property> properties;
  final int page;

  // 🔑 Pagination flags
  final bool isPaginating;
  final bool hasMore;

  const PropertyState({
    this.property,
    this.properties = const [],
    this.page = 0,
    this.status = PropertyStatus.idle,
    this.errorMessage,
    this.isPaginating = false,
    this.hasMore = true,
  });

  PropertyState copyWith({
    Property? property,
    List<Property>? properties,
    PropertyStatus? status,
    String? errorMessage,
    int? page,
    bool? isPaginating,
    bool? hasMore,
  }) {
    return PropertyState(
      property: property ?? this.property,
      properties: properties ?? this.properties,
      status: status ?? this.status,
      errorMessage: errorMessage,
      page: page ?? this.page,
      isPaginating: isPaginating ?? this.isPaginating,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Controller that handles fetching and updating property state
class PropertyController extends StateNotifier<PropertyState> {
  PropertyController() : super(const PropertyState());

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  //  Fetch a property by ID
  // ______________________________________________________________
  /// Fetch a property by ID
  Future<void> fetchPropertyById(String id) async {
    try {
      state = state.copyWith(status: PropertyStatus.loading);

      final url = Uri.parse('$PRO_API_BASE_ROUTE/properties/$id/');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse your API response into the Property model
        final property = Property.fromJson(data);
        if (kDebugMode) {
          print(property);
        }

        state = state.copyWith(
          property: property,
          status: PropertyStatus.loaded,
        );
      } else {
        state = state.copyWith(
          status: PropertyStatus.error,
          errorMessage: 'Failed to fetch property: ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: PropertyStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  //                       FETCH PROPERTIES
  //_________________________________________________________________
  Future<void> fetchProperties({int page = 1, int size = 10}) async {
    // 🔒 Do not start another request if already paginating or exhausted
    if (state.isPaginating || !state.hasMore) return;

    try {
      final isFirstPage = page == 1;

      // Set loading flags
      state = state.copyWith(
        status: isFirstPage ? PropertyStatus.loading : state.status,
        isPaginating: !isFirstPage,
        errorMessage: null,
      );

      // Build URL with query parameters
      final url = Uri.parse('$PRO_API_BASE_ROUTE/properties').replace(
        queryParameters: {'page': page.toString(), 'size': size.toString()},
      );

      if (kDebugMode) {
        print(url);
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<Property> properties = (data as List)
            .map((item) => Property.fromJson(item))
            .toList();

        final merged = isFirstPage
            ? properties
            : [...state.properties, ...properties];

        state = state.copyWith(
          properties: merged,
          page: page,
          hasMore: properties.length == size,
          isPaginating: false,
          status: PropertyStatus.loaded,
        );
      } else {
        state = state.copyWith(
          isPaginating: false,
          status: PropertyStatus.error,
          errorMessage: 'Failed to fetch properties: ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isPaginating: false,
        status: PropertyStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  //
  //_________________________________________________________________

  /// Reset property state
  void clearProperty() {
    state = const PropertyState();
  }

  void clearPropertyErrors() {
    state = state.copyWith(
      status: PropertyStatus.idle, // or whatever "neutral" state you use
      errorMessage: null,
    );
  }
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
//___________________________________________________________________
/// Provider that exposes the controller
final propertyProvider =
    StateNotifierProvider<PropertyController, PropertyState>(
      (ref) => PropertyController(),
    );
