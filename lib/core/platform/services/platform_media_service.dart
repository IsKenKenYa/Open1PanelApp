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

  // Stub: returns false until OHOS native preview plugin is integrated.
  // Keeping this facade so feature pages can migrate incrementally.
  Future<bool> preview(PlatformMediaPreviewRequest request) async {
    return false;
  }
}
