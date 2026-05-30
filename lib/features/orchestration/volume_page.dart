import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/features/orchestration/providers/volume_provider.dart';
import 'package:onepanel_client/features/orchestration/widgets/volume_card.dart';
import 'package:onepanel_client/features/orchestration/widgets/orchestration_resource_page_body.dart';

class VolumePage extends StatefulWidget {
  const VolumePage({super.key});

  @override
  State<VolumePage> createState() => _VolumePageState();
}

class _VolumePageState extends State<VolumePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VolumeProvider>().loadVolumes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VolumeProvider>(
      builder: (context, provider, child) {
        return OrchestrationResourcePageBody(
          items: provider.volumes,
          error: provider.error,
          isLoading: provider.isLoading,
          onRefresh: provider.loadVolumes,
          itemBuilder: (volume) => VolumeCard(volume: volume),
        );
      },
    );
  }
}
