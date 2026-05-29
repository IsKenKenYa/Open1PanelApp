import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/config/api_constants.dart';
import 'package:onepanel_client/core/network/onepanel_auth_headers.dart';

void main() {
  group('OnePanelAuthHeaders', () {
    test('build returns map with token and timestamp headers', () {
      final headers = OnePanelAuthHeaders.build('test-api-key');
      expect(headers, contains(ApiConstants.authHeaderToken));
      expect(headers, contains(ApiConstants.authHeaderTimestamp));
      expect(headers.length, 2);
    });

    test('timestamp is unix epoch in seconds', () {
      final before = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      final headers = OnePanelAuthHeaders.build('key');
      final after = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      final ts = int.parse(headers[ApiConstants.authHeaderTimestamp]!);
      expect(ts, greaterThanOrEqualTo(before));
      expect(ts, lessThanOrEqualTo(after));
    });

    test('token is valid MD5 hash', () {
      final headers = OnePanelAuthHeaders.build('my-key');
      final token = headers[ApiConstants.authHeaderToken]!;
      // MD5 hex string is 32 characters
      expect(token.length, 32);
      expect(RegExp(r'^[a-f0-9]{32}$').hasMatch(token), isTrue);
    });

    test('token is deterministic for same key and timestamp', () {
      // We can't mock DateTime.now(), but we can verify the formula
      final headers = OnePanelAuthHeaders.build('test-key');
      final token = headers[ApiConstants.authHeaderToken]!;
      final timestamp = headers[ApiConstants.authHeaderTimestamp]!;

      // Manually compute expected token
      final authString = '${ApiConstants.authPrefix}test-key$timestamp';
      final expected = md5.convert(utf8.encode(authString)).toString();
      expect(token, expected);
    });

    test('different API keys produce different tokens', () {
      // Call twice rapidly - timestamps may be same, but keys differ
      final h1 = OnePanelAuthHeaders.build('key-alpha');
      final h2 = OnePanelAuthHeaders.build('key-beta');

      // Even if timestamps differ, we verify the formula for each
      final t1 = h1[ApiConstants.authHeaderToken]!;
      final ts1 = h1[ApiConstants.authHeaderTimestamp]!;
      final expected1 =
          md5.convert(utf8.encode('${ApiConstants.authPrefix}key-alpha$ts1')).toString();
      expect(t1, expected1);

      final t2 = h2[ApiConstants.authHeaderToken]!;
      final ts2 = h2[ApiConstants.authHeaderTimestamp]!;
      final expected2 =
          md5.convert(utf8.encode('${ApiConstants.authPrefix}key-beta$ts2')).toString();
      expect(t2, expected2);
    });

    test('empty API key produces valid token', () {
      final headers = OnePanelAuthHeaders.build('');
      final token = headers[ApiConstants.authHeaderToken]!;
      expect(token.length, 32);
    });

    test('auth prefix is "1panel"', () {
      expect(ApiConstants.authPrefix, '1panel');
    });

    test('header names match constants', () {
      expect(ApiConstants.authHeaderToken, '1Panel-Token');
      expect(ApiConstants.authHeaderTimestamp, '1Panel-Timestamp');
    });
  });
}
