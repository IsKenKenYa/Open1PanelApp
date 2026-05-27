import 'package:onepanel_client/core/platform/platform_capabilities.dart';

enum PlatformMediaKind {
  pdf,
  video,
  audio,
}

class PlatformMediaPreviewRequest {
  const PlatformMediaPreviewRequest({
    required this.path,
    required this.kind,
    this.mimeType,
  });

  final String path;
  final PlatformMediaKind kind;
  final String? mimeType;
}

class PlatformMediaService {
  PlatformMediaService({
    PlatformCapabilitiesSnapshot? capabilities,
  }) : _capabilities = capabilities ?? PlatformCapabilities.current();

  final PlatformCapabilitiesSnapshot _capabilities;

  bool get prefersNativePreview => _capabilities.supportsNativeMediaPreview;

  Future<bool> preview(PlatformMediaPreviewRequest request) async {
    // Native OHOS preview is wired as an explicit facade so feature pages can
    // migrate away from package-specific plugins without changing business flow.
    return false;
  }
}
