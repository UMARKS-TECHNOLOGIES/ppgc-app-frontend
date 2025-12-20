import 'dart:async';

import 'package:hooks_riverpod/legacy.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// ===============================
///  ENUMS
/// ===============================

enum ConnectivityStatus { connected, disconnected }

enum ConnectivityRequestStatus { idle, listening, error }

/// ===============================
///  STATE
/// ===============================

class ConnectivityState {
  final ConnectivityStatus connection;
  final ConnectivityRequestStatus status;
  final String? errorMessage;

  const ConnectivityState({
    this.connection = ConnectivityStatus.connected,
    this.status = ConnectivityRequestStatus.idle,
    this.errorMessage,
  });

  ConnectivityState copyWith({
    ConnectivityStatus? connection,
    ConnectivityRequestStatus? status,
    String? errorMessage,
  }) {
    return ConnectivityState(
      connection: connection ?? this.connection,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

/// ===============================
///  CONTROLLER
/// ===============================

class ConnectivityController extends StateNotifier<ConnectivityState> {
  ConnectivityController() : super(const ConnectivityState()) {
    _startListening();
  }

  StreamSubscription<InternetStatus>? _subscription;

  void _startListening() {
    state = state.copyWith(status: ConnectivityRequestStatus.listening);

    _subscription = InternetConnection().onStatusChange.listen(
      (status) {
        final next = status == InternetStatus.connected
            ? ConnectivityStatus.connected
            : ConnectivityStatus.disconnected;

        if (state.connection != next) {
          state = state.copyWith(
            connection: next,
            status: ConnectivityRequestStatus.listening,
          );
        }
      },
      onError: (e) {
        state = state.copyWith(
          status: ConnectivityRequestStatus.error,
          errorMessage: e.toString(),
        );
      },
    );
  }

  bool get isOnline => state.connection == ConnectivityStatus.connected;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// ===============================
///  PROVIDER
/// ===============================

final connectivityProvider =
    StateNotifierProvider<ConnectivityController, ConnectivityState>(
      (ref) => ConnectivityController(),
    );
