import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/api/v2/container_v2.dart';
import 'package:onepanel_client/data/models/container_image_models.dart';

/// Image build/push/save/tag operations page.
/// Mirrors frontend's container image operations.
class ImageOperationsPage extends StatefulWidget {
  const ImageOperationsPage({super.key});

  @override
  State<ImageOperationsPage> createState() => _ImageOperationsPageState();
}

class _ImageOperationsPageState extends State<ImageOperationsPage> {
  final _tagNameController = TextEditingController();
  final _pushNameController = TextEditingController();
  final _sourceController = TextEditingController();
  final _targetController = TextEditingController();
  bool _isBuilding = false;
  bool _isPushing = false;
  bool _isSaving = false;
  bool _isTagging = false;

  @override
  void dispose() {
    _tagNameController.dispose();
    _pushNameController.dispose();
    _sourceController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<ContainerV2Api> _getApi() async {
    return ContainerV2Api(await ApiClientManager.instance.getCurrentClient());
  }

  Future<void> _pushImage() async {
    if (_pushNameController.text.isEmpty) return;
    setState(() => _isPushing = true);
    try {
      final api = await _getApi();
      await api.pushImage(ImagePush(image: _pushNameController.text));
      if (mounted) SnackBarUtils.showSuccess(context, 'Push started');
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Push failed');
    } finally {
      if (mounted) setState(() => _isPushing = false);
    }
  }

  Future<void> _saveImage() async {
    if (_tagNameController.text.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final api = await _getApi();
      await api.saveImage(ImageSave(images: [_tagNameController.text], filePath: '/tmp/${_tagNameController.text}.tar'));
      if (mounted) SnackBarUtils.showSuccess(context, 'Image saved');
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Save failed');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _tagImage() async {
    if (_sourceController.text.isEmpty || _targetController.text.isEmpty) return;
    setState(() => _isTagging = true);
    try {
      final api = await _getApi();
      await api.tagImage(ImageTag(
        sourceImage: _sourceController.text,
        targetImage: _targetController.text,
      ));
      if (mounted) SnackBarUtils.showSuccess(context, 'Tagged');
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Tag failed');
    } finally {
      if (mounted) setState(() => _isTagging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Operations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Push
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Push Image', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pushNameController,
                    decoration: const InputDecoration(
                      labelText: 'Image name (e.g. registry/myimage:v1)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _isPushing ? null : _pushImage,
                    icon: _isPushing
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.upload),
                    label: const Text('Push'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Save
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Save Image to Tar', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tagNameController,
                    decoration: const InputDecoration(
                      labelText: 'Image name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: _isSaving ? null : _saveImage,
                    icon: _isSaving
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.download),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tag
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tag Image', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _sourceController,
                    decoration: const InputDecoration(
                      labelText: 'Source image',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _targetController,
                    decoration: const InputDecoration(
                      labelText: 'Target tag',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: _isTagging ? null : _tagImage,
                    icon: _isTagging
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.label),
                    label: const Text('Tag'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
