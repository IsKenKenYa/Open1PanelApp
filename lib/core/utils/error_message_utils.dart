import 'package:dio/dio.dart';

import '../network/network_exceptions.dart';

/// Centralised error-to-user-message translation.
///
/// This is the seam between typed infrastructure exceptions (DioException,
/// NetworkException subtypes) and user-facing display text. Providers should
/// call [userFacingMessage] instead of `e.toString()` so typed error
/// information is preserved and translated consistently (architecture review
/// candidate ⑭ -- the "e.toString() flattening" root cause).
class ErrorMessageUtils {
  const ErrorMessageUtils._();

  /// Translates [error] to a user-facing message string.
  ///
  /// When [error] is a [DioException] or [NetworkException] subtype, a
  /// type-appropriate default message is returned (without hard-coded UI
  /// text -- callers can still l10n-override if needed). For other errors,
  /// the [toString] output is cleaned of common prefix noise.
  static String normalize(Object error) {
    // DioException: translate by type so the UI never sees raw Dio internals.
    if (error is DioException) {
      return _normalizeDioException(error);
    }

    // NetworkException subtypes: use the message field directly (it already
    // carries a human-readable summary from dio_client._convertException).
    if (error is NetworkException) {
      return error.message.trim();
    }

    final message = error.toString().trim();
    if (message.isEmpty) {
      return message;
    }

    const prefixes = <String>[
      'Exception: ',
      'NetworkException: ',
    ];
    for (final prefix in prefixes) {
      if (message.startsWith(prefix)) {
        return message.substring(prefix.length).trim();
      }
    }
    return message;
  }

  /// Returns a user-facing message capped at [maxLength] characters.
  static String userFacingMessage(
    Object error, {
    int maxLength = 120,
  }) {
    final normalized = normalize(error);
    if (normalized.isEmpty) {
      return normalized;
    }
    return truncateForToast(normalized, maxLength: maxLength);
  }

  /// 120 chars fits a single-line SnackBar on most phones without wrapping.
  static String truncateForToast(
    String message, {
    int maxLength = 120,
  }) {
    final trimmed = message.trim();
    if (trimmed.length <= maxLength) {
      return trimmed;
    }
    // Use ellipsis character (…) rather than "..." to save 2 chars and match typographic norms
    return '${trimmed.substring(0, maxLength - 1)}…';
  }

  static String _normalizeDioException(DioException error) {
    // Extract the server-provided message when available; otherwise fall
    // back to a type-based summary. This prevents the UI from seeing raw
    // "DioException [bad response]: ..." strings.
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final serverMessage = responseData['message'];
      if (serverMessage is String && serverMessage.trim().isNotEmpty) {
        return serverMessage.trim();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out';
      case DioExceptionType.connectionError:
        return 'Network connection failed';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return 'Unauthorized';
        if (statusCode == 403) return 'Forbidden';
        if (statusCode == 404) return 'Not found';
        if (statusCode != null && statusCode >= 500) {
          return 'Server error ($statusCode)';
        }
        return 'Request failed ($statusCode)';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.badCertificate:
        return 'Certificate error';
      case DioExceptionType.unknown:
        return error.message?.trim().isNotEmpty == true
            ? error.message!.trim()
            : 'Unknown network error';
    }
  }
}

