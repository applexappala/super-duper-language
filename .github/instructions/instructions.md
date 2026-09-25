# Custom Instructions for super_duper_language

You are an expert Flutter developer specialized in Clean Architecture and the Bloc pattern. This project follows a premium design and architecture stack.

## Architecture & State Management

- **Pattern**: Clean Architecture (Presentation, Domain, Data).
- **State Management**: Use `flutter_bloc` exclusively.
- **Dependency Injection**: Use `get_it` with `injectable`. Annotate dependencies with `@injectable`, `@lazySingleton`, etc., and run code generation.
- **Initialization**: Initialization of DI should be in `lib/core/di/injection.dart`.
- **Standard UseCases**: Logic in the domain layer MUST extend the `UseCase<Type, Params>` base class found in `lib/core/usecase/usecase.dart`.
- **Error Handling**:
  - Domain and Data layers should return `Either<Failure, Type>`.
  - Use the standard `Failure` classes in `lib/core/error/failures.dart` (ServerFailure, NetworkFailure, etc.).

## UI & Design Language

- **UI Framework**: **shadcn_ui** is the primary UI system. ALL UI components MUST come from `shadcn_ui`. Avoid pure Material/Cupertino unless necessary.
- **Responsiveness**: Use `responsive_framework`.
  - **CRITICAL**: DO NOT use `MediaQuery` for layout comparisons. Use `ResponsiveBreakpoints.of(context).isMobile`, `.isTablet`, etc.
- **Animations**: Use the `animations` package for transitions and micro-interactions.
- **Feedback**: Use `flutter_easy_loading` for ALL service loading, success, error, or failed indicators.
  - Example: `EasyLoading.show(status: 'loading...')`, `EasyLoading.showError('Failed!')`.

## Assets & Configuration

- **Launcher Icons**: Configuration is in `pubspec.yaml`.
  - Place the new icon at `assets/images/launcher_icon.png`.
  - Command to generate: `dart run flutter_launcher_icons`
- **Splash Screen**: Configuration is in `pubspec.yaml`.
  - Place the splash icon at `assets/images/splash_icon.png`.
  - Command to generate: `dart run flutter_native_splash:create`
- **AI Guidance**: When a user provides an image for an icon or splash:
  1.  Save the image to `assets/images/launcher_icon.png` or `assets/images/splash_icon.png`.
  2.  Run the corresponding generation command above.
  3.  These commands are safe to run automatically if requested.

## Firebase Setup

- **Procedure**: ALWAYS use `flutterfire configure` (from the FlutterFire CLI) to set up or update Firebase.
- This ensures `google-services.json` and `GoogleService-Info.plist` are correctly pulled and the `firebase_options.dart` is generated.
- DO NOT manually copy-paste Firebase config files unless `flutterfire` fails.

## Data Models & Serialization

- **ONLY `freezed` is permitted** for any data model, entity, DTO, or response class that requires `toJson` / `fromJson`.
- **NEVER** use `json_serializable` alone, manual `toJson`/`fromJson` methods, or any other serialization package (`dart_mappable`, `built_value`, etc.).
- Every serializable model MUST follow this exact pattern:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    String? email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

- After creating or modifying any `@freezed` class, run:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- For union/sealed states (e.g., Bloc states and events), use `@freezed` without `fromJson`/`toJson` unless persistence is needed.
- Do **not** add `part '*.g.dart'` unless the class has `fromJson` — omit it for pure union types.

## Coding Standards

- Use `ShadApp` as the root widget.
- Prefer `ShadButton`, `ShadInput`, `ShadCard`, etc.
- Follow the design principles of Shadcn UI: clean, accessible, and minimalist.
- **Centralized Theming**:
  - ALL common styles (colors, border radius, button padding, etc.) MUST be defined in `lib/core/theme/app_theme.dart`.
  - DO NOT define ad-hoc styles, colors, or component themes inside individual widgets.
  - Reference colors via `ShadTheme.of(context).colorScheme` and text styles via `ShadTheme.of(context).textTheme`.
- Keep widgets small and focused.
- Handle all edge cases and error states using `EasyLoading`.
- Documentation: Add docstrings to public classes and methods.

## Commands (Allowlist)

The following commands are approved for execution:

- `flutter pub get`
- `dart run build_runner build --delete-conflicting-outputs`
- `dart run flutter_launcher_icons`
- `dart run flutter_native_splash:create`
- `flutterfire configure`
