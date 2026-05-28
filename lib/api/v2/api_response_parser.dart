import 'package:dio/dio.dart';

import '../../data/models/common_models.dart';

class ApiResponseParser {
  const ApiResponseParser._();

  static dynamic unwrap(dynamic payload) {
    if (payload is Map<String, dynamic> && payload.containsKey('data')) {
      return payload['data'];
    }
    return payload;
  }

  static Map<String, dynamic> asMap(
    dynamic payload, {
    bool fallbackToRootMap = false,
  }) {
    final data = unwrap(payload);
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (fallbackToRootMap && payload is Map<String, dynamic>) {
      return payload;
    }
    if (fallbackToRootMap && payload is Map) {
      return Map<String, dynamic>.from(payload);
    }
    return const <String, dynamic>{};
  }

  static List<dynamic> asList(
    dynamic payload, {
    String? nestedItemsKey,
  }) {
    final data = unwrap(payload);
    if (data is List<dynamic>) {
      return data;
    }
    if (data is List) {
      return List<dynamic>.from(data);
    }
    if (nestedItemsKey != null && data is Map<String, dynamic>) {
      final nested = data[nestedItemsKey];
      if (nested is List<dynamic>) {
        return nested;
      }
      if (nested is List) {
        return List<dynamic>.from(nested);
      }
    }
    return const <dynamic>[];
  }

  static T? asPrimitive<T>(dynamic payload) {
    final data = unwrap(payload);
    if (data is T) {
      return data;
    }
    return null;
  }

  static Map<String, dynamic>? asMapOrNull(dynamic payload) {
    final result = asMap(payload);
    return result.isEmpty ? null : result;
  }

  static List<dynamic>? asListOrNull(dynamic payload) {
    if (payload is! Map<String, dynamic>) return null;
    final data = payload['data'];
    if (data is List<dynamic>) return data;
    if (data is List) return List<dynamic>.from(data);
    return null;
  }

  static String? asStringOrNull(dynamic payload) {
    final data = unwrap(payload);
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }

  static T extractData<T>(
    Response<Map<String, dynamic>> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final payload = asMap(response.data);
    if (payload.isEmpty) {
      // 避免当返回 { "code": 200, "message": "successful", "data": null } 且 T 允许为空结构时抛出异常
      // 我们可以传空的 map 给 fromJson
      try {
        return fromJson(const <String, dynamic>{});
      } catch (e) {
        throw Exception('API response missing data map and cannot parse empty map: $e');
      }
    }
    return fromJson(payload);
  }

  static Map<String, dynamic> extractMapData(
    Response<Map<String, dynamic>> response,
  ) {
    return asMap(response.data);
  }

  static List<dynamic> extractListData(
    Response<Map<String, dynamic>> response, {
    String? nestedItemsKey,
  }) {
    return asList(response.data, nestedItemsKey: nestedItemsKey);
  }

  static dynamic extractDynamicData(Response<Map<String, dynamic>> response) {
    return unwrap(response.data);
  }

  static Response<T> withData<T>(Response<dynamic> source, T data) {
    return Response<T>(
      data: data,
      statusCode: source.statusCode,
      statusMessage: source.statusMessage,
      requestOptions: source.requestOptions,
      headers: source.headers,
      extra: source.extra,
      redirects: source.redirects,
      isRedirect: source.isRedirect,
    );
  }

  static List<T> extractListDataFromMap<T>(
    Response<Map<String, dynamic>> response,
    T Function(Map<String, dynamic>) fromJson, {
    String nestedItemsKey = 'items',
  }) {
    final data = asList(response.data, nestedItemsKey: nestedItemsKey);
    return data
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList(growable: false);
  }

  static List<Map<String, dynamic>> extractRawListDataFromMap(
    Response<Map<String, dynamic>> response, {
    String nestedItemsKey = 'items',
  }) {
    final data = asList(response.data, nestedItemsKey: nestedItemsKey);
    return data.whereType<Map<String, dynamic>>().toList(growable: false);
  }

  static PageResult<T> extractPageData<T>(
    Response<Map<String, dynamic>> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = asMap(response.data);
    if (data.isNotEmpty) {
      return PageResult.fromJson(
        data,
        (dynamic item) => fromJson(item as Map<String, dynamic>),
      );
    }
    return PageResult<T>(items: const [], total: 0);
  }
}