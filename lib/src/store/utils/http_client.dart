sealed class NetworkException implements Exception {
  const NetworkException();

  factory NetworkException.noInternet() = NoInternetException;
  factory NetworkException.dnsFailure() = DnsFailureException;
  factory NetworkException.unknown(String message) = UnknownNetworkException;
}

class NoInternetException extends NetworkException {
  const NoInternetException();
}

class DnsFailureException extends NetworkException {
  const DnsFailureException();
}

class UnknownNetworkException extends NetworkException {
  final String message;
  const UnknownNetworkException(this.message);
}
