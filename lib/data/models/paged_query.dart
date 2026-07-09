import 'package:equatable/equatable.dart';

/// Unified pagination query value object.
///
/// Consolidates the scattered `pageSize` defaults (20/50/100/200) into a
/// single source of truth (architecture review candidate ⑫/㉑). All
/// paginated API calls should use this instead of ad-hoc page/pageSize
/// parameters.
class PagedQuery extends Equatable {
  const PagedQuery({
    this.page = 1,
    this.pageSize = defaultPageSize,
  });

  /// The default page size used across all paginated endpoints.
  static const int defaultPageSize = 10;

  /// Domain-specific defaults for modules that need larger pages.
  static const int listPageSize = 100;
  static const int searchPageSize = 20;
  static const int mediumPageSize = 50;
  static const int logPageSize = 200;

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [page, pageSize];
}
