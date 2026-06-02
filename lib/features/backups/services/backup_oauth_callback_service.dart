import 'dart:async';

import 'package:app_links/app_links.dart';

class BackupOauthCallbackService {
  BackupOauthCallbackService({
    AppLinks? appLinks,
  }) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;
  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();
  StreamSubscription<Uri>? _subscription;
  Uri? _initialUri;

  Stream<Uri> get callbacks => _controller.stream;

  Future<void> start() async {
    // Capture the deep link that launched the app (if any) — this handles
    // the case where the OAuth redirect opens the app from a cold start.
    if (_initialUri == null) {
      final dynamic initial = await (_appLinks as dynamic).getInitialLink();
      if (initial is Uri) {
        _initialUri = initial;
      } else if (initial is String) {
        _initialUri = Uri.tryParse(initial);
      }
    }
    _subscription ??= _appLinks.uriLinkStream.listen(_controller.add);
  }

  // Consume-once pattern: the initial URI is only relevant once per app launch.
  Uri? consumeInitialUri() {
    final uri = _initialUri;
    _initialUri = null;
    return uri;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
