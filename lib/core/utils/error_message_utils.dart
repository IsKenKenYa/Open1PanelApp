import '../network/network_exceptions.dart';

class ErrorMessageUtils {
  const ErrorMessageUtils._();

  static String normalize(Object error) {
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

  static String truncateForToast(
    String message, {
    int maxLength = 120,
  }) {
    final trimmed = message.trim();
    if (trimmed.length <= maxLength) {
      return trimmed;
    }
    return '${trimmed.substring(0, maxLength - 1)}…';
  }
}
