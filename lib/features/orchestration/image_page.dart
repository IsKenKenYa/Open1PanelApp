import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/features/orchestration/providers/image_provider.dart';
import 'package:onepanel_client/features/orchestration/widgets/image_card.dart';
import 'package:onepanel_client/features/orchestration/widgets/orchestration_resource_page_body.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DockerImageProvider>().loadImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DockerImageProvider>(
      builder: (context, provider, child) {
        return OrchestrationResourcePageBody(
          items: provider.images,
          error: provider.error,
          isLoading: provider.isLoading,
          onRefresh: provider.loadImages,
          itemBuilder: (image) => ImageCard(image: image),
        );
      },
    );
  }
}
