# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**1Panel Open** is a cross-platform Flutter mobile application that provides mobile access to the 1Panel Linux server management panel. The app serves as a mobile interface for managing server applications, containers, websites, files, and AI features through a modern, responsive UI.

### Current Implementation Status
- ✅ **AI Management Module**: Complete (Ollama models, GPU monitoring, domain binding)
- ✅ **Server Configuration**: Multi-server support with API key authentication
- ✅ **Core Infrastructure**: Logging, i18n (EN/ZH), navigation, Material Design 3
- 🚧 **Dashboard**: Planned
- 🚧 **Application/Container/File Management**: UI stubs ready

## Development Commands

### Essential Commands
```bash
# Development
flutter pub get              # Install dependencies
flutter run                 # Run app in debug mode
flutter test                # Run all tests
flutter analyze             # Static analysis with linting

# Building
flutter build apk --release # Build Android APK for release
flutter build appbundle     # Build Android App Bundle
flutter build ios --release # Build iOS release (macOS only)

# Code Generation
flutter packages pub run build_runner build  # Generate model serialization files
flutter packages pub run build_runner watch  # Watch for changes and auto-generate
```

### Testing
```bash
flutter test                  # Run all tests
flutter test test/specific_test.dart  # Run specific test file
flutter test --coverage       # Run tests with coverage report
```

## Architecture Overview

### Core Architecture Pattern
The project follows **Layered Architecture with MVVM** and clean separation of concerns:

```
├── Presentation Layer (UI)
│   ├── Pages (Screens)     # lib/pages/
│   └── Widgets            # lib/shared/widgets/
├── Business Logic Layer (ViewModels/Providers)
│   ├── State Management   # Provider pattern with ChangeNotifier
│   └── Use Cases         # Feature-specific business logic
├── Data Access Layer (Repositories/Services)
│   ├── API Services       # lib/api/v2/ (type-safe with Retrofit)
│   └── Data Models        # lib/data/models/
└── Infrastructure Layer
    ├── Network Client     # Dio-based HTTP client
    ├── Storage           # Secure storage + SharedPreferences
    └── Core Services      # lib/core/services/
```

### Key Technologies
- **Flutter**: 3.16+ with Material Design 3
- **State Management**: Provider pattern (ChangeNotifier)
- **Networking**: Dio + Retrofit for type-safe HTTP clients
- **Storage**: Flutter Secure Storage + SharedPreferences
- **Authentication**: MD5 token generation (`1panel` + API-Key + UnixTimestamp)
- **Internationalization**: Built-in Flutter i18n (English/Chinese)

### Project Structure Rules (CRITICAL)

#### File Organization Rule
When a functional module has ≥2 files, **MUST** create a dedicated subfolder to avoid mixing different responsibilities in the same folder.

**Example (CORRECT)**:
```
lib/
├── core/
│   ├── auth/
│   │   ├── auth_service.dart
│   │   └── auth_repository.dart
│   └── network/
│       ├── network_service.dart
│       └── network_repository.dart
```

#### File Naming Conventions
- **Pages**: `_page.dart` suffix (e.g., `home_page.dart`)
- **Widgets**: `_widget.dart` suffix (e.g., `user_card_widget.dart`)
- **Services**: `_service.dart` suffix (e.g., `api_service.dart`)
- **Models**: `_model.dart` suffix (e.g., `user_model.dart`)
- **Repositories**: `_repository.dart` suffix (e.g., `user_repository.dart`)
- **All files**: lowercase with underscores (e.g., `server_config_page.dart`)

### Current Directory Structure
```
lib/
├── api/v2/              # Type-safe API clients (Retrofit-generated)
├── config/              # App configurations
├── core/                # Core services and utilities
│   ├── config/         # Configuration management
│   ├── i18n/           # Internationalization
│   ├── network/        # Network client setup
│   └── services/       # Core services (logger, etc.)
├── data/               # Data layer
│   ├── models/         # Data models with JSON serialization
│   └── repositories/   # Data repositories
├── features/           # Feature modules (currently AI only)
├── pages/              # UI pages/screens
├── shared/             # Shared components
│   ├── constants/      # App constants
│   └── widgets/        # Reusable widgets
└── main.dart           # App entry point
```

## Critical Development Rules

### Logging System (MANDATORY)
**NEVER** use `print()` or `debugPrint()`. Use the unified logging system:

```dart
import 'core/services/logger_service.dart';

// With explicit package name (RECOMMENDED)
appLogger.dWithPackage('auth.service', '用户登录成功');
appLogger.eWithPackage('network.api', '请求失败', error: e, stackTrace: stackTrace);

// With package prefix in message
appLogger.d('[auth.service] 这是一条调试信息');
```

#### Package Naming Convention
- Use lowercase with dots: `auth.service`, `network.api`, `features.dashboard`
- Correspond to file path: `lib/features/dashboard/` → `[features.dashboard]`
- Default package: `[core.services]` if not specified

#### Log Levels by Build Mode
- **Debug**: All levels (Trace, Debug, Info, Warning, Error, Fatal)
- **Profile**: Info, Warning, Error, Fatal
- **Release**: Warning, Error, Fatal only

### Code Quality Standards
- **Every commit must**: Compile, pass tests, follow linting rules
- **Analysis**: Run `flutter analyze` before committing
- **Lint rules**: Enabled in `analysis_options.yaml` with `avoid_print: true`
- **Code generation**: Use `build_runner` for JSON serialization and API clients

### API Integration Pattern
```dart
// Example API client usage
final apiClient = ApiClient();
final response = await apiClient.getApps();
// Use try-catch with proper logging
try {
  final result = await apiClient.someMethod();
  appLogger.iWithPackage('api.client', '操作成功');
} catch (e, stackTrace) {
  appLogger.eWithPackage('api.client', '操作失败', error: e, stackTrace: stackTrace);
  rethrow; // Re-throw for UI handling
}
```

## Authentication System

### Token Generation
API authentication uses MD5 hash: `md5('1panel' + apiKey + unixTimestamp)`

### Multi-Server Support
- Server configurations stored securely
- Support for multiple 1Panel servers
- Default server selection available

## Feature Development Guidelines

### Adding New Features
1. **Create feature folder** under `lib/features/feature_name/`
2. **Follow structure**:
   ```
   features/feature_name/
   ├── data/
   │   ├── models/
   │   └── repositories/
   ├── presentation/
   │   ├── pages/
   │   └── widgets/
   └── domain/
       └── use_cases/
   ```
3. **Add API client** in `lib/api/v2/` if needed
4. **Create state provider** extending ChangeNotifier
5. **Use unified logging** with appropriate package names

### State Management Pattern
```dart
class FeatureProvider extends ChangeNotifier {
  final _repository = FeatureRepository();

  // State variables
  bool _isLoading = false;
  List<FeatureModel> _items = [];

  // Getters
  bool get isLoading => _isLoading;
  List<FeatureModel> get items => _items;

  // Actions
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _repository.getItems();
      appLogger.iWithPackage('feature.provider', '数据加载成功');
    } catch (e, stackTrace) {
      appLogger.eWithPackage('feature.provider', '数据加载失败', error: e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

## Testing Guidelines

### Test Structure
```dart
// Unit test example
void main() {
  group('FeatureProvider', () {
    late FeatureProvider provider;
    late MockRepository mockRepository;

    setUp(() {
      mockRepository = MockRepository();
      provider = FeatureProvider(mockRepository);
    });

    test('should load items successfully', () async {
      // Arrange
      final expectedItems = [FeatureModel(id: 1, name: 'Test')];
      when(mockRepository.getItems()).thenAnswer((_) async => expectedItems);

      // Act
      await provider.loadItems();

      // Assert
      expect(provider.items, expectedItems);
      expect(provider.isLoading, false);
    });
  });
}
```

## UI/UX Guidelines

### Material Design 3
- Use Material 3 components and theming
- Follow accessibility guidelines
- Implement responsive design for different screen sizes

### Internationalization
- All user-facing strings must use `AppLocalizations`
- Support English (en) and Chinese (zh)
- Add new keys to `lib/core/i18n/app_localizations.dart`

## Security Considerations

### Data Storage
- **Sensitive data**: Use `FlutterSecureStorage`
- **Preferences**: Use `SharedPreferences`
- **API keys**: Store securely, never log them

### Network Security
- All API calls use HTTPS
- Custom headers for authentication
- Certificate pinning if needed

## Common Development Workflows

### Adding New API Endpoint
1. Update API client in `lib/api/v2/`
2. Add data models in `lib/data/models/`
3. Run code generation: `flutter packages pub run build_runner build`
4. Create repository methods
5. Add provider actions
6. Update UI with proper loading/error states

### Debugging Tips
- Use Debug mode for comprehensive logging
- Filter logs by package name: `[feature.provider]`
- Check network logs with Dio interceptors
- Use Flutter Inspector for widget debugging

### Performance Considerations
- Use `const` constructors where possible
- Implement proper image caching with `cached_network_image`
- Use `shimmer` for loading states
- Avoid expensive operations in build methods

## Build and Deployment

### Android
```bash
flutter build apk --release          # Release APK
flutter build appbundle              # App Bundle for Play Store
```

### iOS (macOS only)
```bash
flutter build ios --release          # Release build
```

### Code Signing
- Configure in respective platform folders
- Use environment variables for sensitive keys
- Never commit signing certificates