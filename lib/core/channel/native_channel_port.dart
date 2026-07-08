/// Abstract port for native channel operations.
///
/// Enables test substitution and native UI mock injection (architecture
/// review candidate ⑬/㉑). The concrete [NativeChannelManager] implements
/// this interface; tests or alternative platforms can provide a mock
/// implementation via constructor injection.
///
/// Currently the native channel dispatch is static-only; this interface
/// exists as the seam that future refactoring will wire through
/// [NativeChannelManager]'s constructor.
abstract class NativeChannelPort {
  /// Initializes the native channel handler (instance method).
  void initInstance();

  /// Dispatches a native method call to the appropriate handler.
  Future<dynamic> handleMethodCall(String method, dynamic arguments);
}
