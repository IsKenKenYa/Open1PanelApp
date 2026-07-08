import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/shared/state/selection_controller.dart';

void main() {
  late SelectionController<int> controller;

  setUp(() {
    controller = SelectionController<int>();
  });

  group('SelectionController', () {
    test('toggle adds and removes items', () {
      expect(controller.hasSelection, isFalse);

      controller.toggle(1);
      expect(controller.selectedIds, {1});
      expect(controller.hasSelection, isTrue);
      expect(controller.isSelected(1), isTrue);

      controller.toggle(1);
      expect(controller.selectedIds, isEmpty);
      expect(controller.isSelected(1), isFalse);
    });

    test('select and deselect are idempotent', () {
      controller.select(1);
      controller.select(1);
      expect(controller.selectedIds, {1});

      controller.deselect(1);
      controller.deselect(1);
      expect(controller.selectedIds, isEmpty);
    });

    test('selectAll replaces current selection', () {
      controller.toggle(1);
      controller.selectAll([2, 3, 4]);
      expect(controller.selectedIds, {2, 3, 4});
      expect(controller.selectedCount, 3);
    });

    test('clear empties the selection', () {
      controller.selectAll([1, 2, 3]);
      controller.clear();
      expect(controller.selectedIds, isEmpty);
    });

    test('clear is a no-op when already empty', () {
      controller.clear();
      expect(controller.selectedIds, isEmpty);
    });

    test('toList returns a fixed-length list', () {
      controller.selectAll([1, 2, 3]);
      final list = controller.toList();
      expect(list, [1, 2, 3]);
      expect(() => list.add(4), throwsUnsupportedError);
    });

    test('selectedIds is unmodifiable', () {
      controller.toggle(1);
      expect(() => controller.selectedIds.add(2), throwsUnsupportedError);
    });

    test('notifies listeners on change', () {
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.toggle(1);
      controller.toggle(1);
      controller.selectAll([2, 3]);
      controller.clear();

      expect(notifyCount, 4);
    });
  });
}
