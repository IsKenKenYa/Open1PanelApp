import 'package:flutter/foundation.dart';

/// A reusable selection controller for batch-operation UIs.
///
/// Consolidates the 7+ duplicated `Set<T> _selectedIds` + toggle/selectAll/
/// clear patterns that were previously spread across Widget states and
/// Providers (architecture review candidate ⑨). This deep module provides
/// a single, testable selection API that any module can inject.
///
/// Usage in a Provider:
/// ```dart
/// final SelectionController<int> selection = SelectionController();
/// void toggleSelection(int id) => selection.toggle(id);
/// ```
///
/// Usage in a Widget state:
/// ```dart
/// final SelectionController<FirewallRule> _selection = SelectionController();
/// ```
class SelectionController<T extends Object> extends ChangeNotifier {
  final Set<T> _selected = <T>{};

  /// An unmodifiable view of the currently selected items.
  Set<T> get selectedIds => Set<T>.unmodifiable(_selected);

  /// Whether any item is selected.
  bool get hasSelection => _selected.isNotEmpty;

  /// The number of selected items.
  int get selectedCount => _selected.length;

  /// Whether [item] is currently selected.
  bool isSelected(T item) => _selected.contains(item);

  /// Toggles the selection state of [item].
  void toggle(T item) {
    if (_selected.contains(item)) {
      _selected.remove(item);
    } else {
      _selected.add(item);
    }
    notifyListeners();
  }

  /// Adds [item] to the selection (no-op if already selected).
  void select(T item) {
    if (_selected.add(item)) {
      notifyListeners();
    }
  }

  /// Removes [item] from the selection (no-op if not selected).
  void deselect(T item) {
    if (_selected.remove(item)) {
      notifyListeners();
    }
  }

  /// Selects all items in [items], replacing the current selection.
  void selectAll(Iterable<T> items) {
    _selected
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  /// Clears all selected items.
  void clear() {
    if (_selected.isEmpty) return;
    _selected.clear();
    notifyListeners();
  }

  /// Returns the selected items as a growable list (useful for batch actions).
  List<T> toList() => _selected.toList(growable: false);
}
