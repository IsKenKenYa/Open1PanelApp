import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/services/app_preferences_service.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';

/// Toggle tile for the "use system file picker for file operations"
/// preference. Extracted from system_settings_page.dart to reduce file
/// size below the 1000 LOC hard limit (architecture review R5 candidate 2).
class FilePickerToggleTile extends StatefulWidget {
  const FilePickerToggleTile({super.key, required this.onChanged});

  final VoidCallback onChanged;

  @override
  State<FilePickerToggleTile> createState() => _FilePickerToggleTileState();
}

class _FilePickerToggleTileState extends State<FilePickerToggleTile> {
  static final AppPreferencesService _prefs = AppPreferencesService();

  bool? _usePicker;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await _prefs.loadUseFilePickerForFileOperations();
    if (!mounted) return;
    setState(() {
      _usePicker = value;
    });
  }

  Future<void> _onChanged(bool value) async {
    if (_busy) return;
    setState(() {
      _busy = true;
    });
    try {
      await _prefs.saveUseFilePickerForFileOperations(value);
      if (!mounted) return;
      setState(() {
        _usePicker = value;
      });
      widget.onChanged();
    } catch (error, stackTrace) {
      appLogger.eWithPackage(
        'features.settings.system_settings',
        'Failed to persist useFilePickerForFileOperations',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final value = _usePicker;
    return SwitchListTile(
      secondary: const Icon(Icons.folder_open_outlined),
      title: Text(l10n.systemSettingsFileExportUsePicker),
      subtitle: Text(l10n.systemSettingsFileExportUsePickerDesc),
      value: value ?? true,
      onChanged: value == null || _busy ? null : _onChanged,
    );
  }
}

/// State tile for the "default sub-folder name" preference.
class FileSaveSubDirectoryTile extends StatefulWidget {
  const FileSaveSubDirectoryTile({super.key, required this.onChanged});

  final VoidCallback onChanged;

  @override
  State<FileSaveSubDirectoryTile> createState() =>
      _FileSaveSubDirectoryTileState();
}

class _FileSaveSubDirectoryTileState extends State<FileSaveSubDirectoryTile> {
  static final AppPreferencesService _prefs = AppPreferencesService();

  late final TextEditingController _controller;
  bool _busy = false;

  static final RegExp _illegalChars = RegExp(r'[<>:"/\\|?*\x00-\x1F]');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final value = await _prefs.loadFileSaveSubDirectoryName();
    if (!mounted) return;
    if (_controller.text != value) {
      _controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  Future<void> _commit(String raw) async {
    if (_busy) return;
    final sanitized = raw.replaceAll(_illegalChars, '_');
    setState(() {
      _busy = true;
    });
    try {
      await _prefs.saveFileSaveSubDirectoryName(sanitized);
      if (!mounted) return;
      if (sanitized != raw) {
        _controller.value = TextEditingValue(
          text: sanitized,
          selection: TextSelection.collapsed(offset: sanitized.length),
        );
      }
      widget.onChanged();
    } catch (error, stackTrace) {
      appLogger.eWithPackage(
        'features.settings.system_settings',
        'Failed to persist fileSaveSubDirectoryName',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.create_new_folder_outlined),
      title: SizedBox(
        height: 72,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: l10n.systemSettingsFileExportSubDirTitle,
            helperText: l10n.systemSettingsFileExportSubDirHelper,
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: _commit,
          onEditingComplete: () => _commit(_controller.text),
        ),
      ),
    );
  }
}
