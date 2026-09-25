# super_duper_language

You are an expert Flutter developer specialized in Clean Architecture and the Bloc pattern. Follow the conventions below strictly.

## Project Structure

```
lib/
  core/
    di/         # GetIt + injectable setup (injection.dart, injection.config.dart)
    error/      # Failure base classes
    network/    # Dio client singleton
    theme/      # App theme (app_theme.dart)
    usecase/    # UseCase base class
    util/       # Shared utilities
  features/
    <feature>/
      data/
        datasources/
        models/       # @freezed DTOs
        repositories/ # implementations
      domain/
        entities/
        repositories/ # interfaces
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
```

## Architecture

**Clean Architecture** with three layers:

- **Presentation** — Widgets, BLoCs, and pages. No business logic here.
- **Domain** — Entities, UseCases, and repository interfaces. Pure Dart, no Flutter imports.
- **Data** — Repository implementations, DTOs, and data sources (remote/local).

All use cases MUST extend `UseCase<Type, Params>` from `lib/core/usecase/usecase.dart`. Use `NoParams` when no parameters are needed.

Domain and Data layers return `Either<Failure, Type>` (dartz). Use the standard `Failure` subclasses in `lib/core/error/failures.dart` (`ServerFailure`, `NetworkFailure`, `CacheFailure`, `AuthenticationFailure`).

## State Management & DI

- State management: `flutter_bloc` exclusively — no Provider, Riverpod, or GetX.
- DI: `get_it` + `injectable`. Annotate with `@injectable`, `@lazySingleton`, `@singleton`, etc.
- DI initialization lives in `lib/core/di/injection.dart`. Call `configureDependencies()` in `main()`.
- After adding or modifying injectable classes, run code generation (see Commands).

## UI & Design

- **Primary UI system**: `shadcn_ui` — use `ShadButton`, `ShadInput`, `ShadCard`, `ShadDialog`, etc. Avoid raw Material/Cupertino widgets unless unavoidable.
- **Icons**: use `lucide_icons` (already imported via `shadcn_ui`). Do not add `material_icons` or other icon packages.
- **Root widget**: `ShadApp` (not `MaterialApp`).
- **Responsiveness**: `responsive_framework` only. NEVER use `MediaQuery` for layout comparisons.

  Breakpoints defined in `main.dart`:
  | Name    | Range (px)       |
  |---------|-----------------|
  | MOBILE  | 0 – 450         |
  | TABLET  | 451 – 800       |
  | DESKTOP | 801 – 1920      |
  | 4K      | 1921 – ∞        |

  Usage: `ResponsiveBreakpoints.of(context).isMobile` / `.isTablet` / `.isDesktop` / `.equals('4K')`

- **Animations**: use the `animations` package for page transitions and micro-interactions.
- **Loading / feedback**: use `flutter_easyloading` for ALL async indicators.
  - `EasyLoading.show(status: 'Loading...')`
  - `EasyLoading.showSuccess('Done!')`
  - `EasyLoading.showError('Failed!')`
  - `EasyLoading.dismiss()`
- **Toasts**: use `ShadToaster.of(context).show(ShadToast(...))` — never `SnackBar`.

## Theming

All colors, text styles, and component themes MUST be defined in `lib/core/theme/app_theme.dart`. Do not define ad-hoc styles inside widgets.

Reference in widgets:
- Colors: `ShadTheme.of(context).colorScheme.primary`
- Text: `ShadTheme.of(context).textTheme.h1`

## Data Models & Serialization

`freezed` is the **only** permitted serialization/model tool. Never use `json_serializable` alone, manual `toJson`/`fromJson`, `dart_mappable`, or `built_value`.

Every serializable model pattern:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart'; // only when fromJson is needed

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

For union/sealed types (BLoC states and events), use `@freezed` without `fromJson`/`toJson` and omit the `part '*.g.dart'` line.

After creating or modifying any `@freezed` class, run code generation (see Commands).

## Networking

`Dio` is configured as a `@lazySingleton` in `lib/core/network/dio_client.dart`. Set `baseUrl` there. `PrettyDioLogger` is pre-wired for debug output.

## Secure Storage

Use `flutter_secure_storage` for storing tokens and sensitive data. Never store secrets in `SharedPreferences`.

## Force Update

`force_update_helper` is included. Wire it up in the root widget or app startup to gate users on minimum version requirements.

## Firebase

Services included: `firebase_core`, `firebase_crashlytics`, `firebase_app_check`, `firebase_remote_config`.

Always use `flutterfire configure` to set up or update Firebase. This generates `firebase_options.dart` and places `google-services.json` / `GoogleService-Info.plist`. Do NOT manually copy Firebase config files unless `flutterfire` fails.

Firebase initialization in `main()` is commented out by default — uncomment and call:
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

## Assets

- Launcher icon: `assets/icon/launcher_icon.png` — configured in `pubspec.yaml` under `flutter_launcher_icons`.
- Splash image: `assets/images/splash_image.png` — configured in `pubspec.yaml` under `flutter_native_splash`.

When a user provides an icon or splash image:
1. Save to the correct path above.
2. Run the corresponding generation command (see Commands).

## Coding Standards

- Keep widgets small and focused — extract sub-widgets freely.
- Handle all error and empty states explicitly.
- Add docstrings to public classes and methods.
- Do not define colors or styles inline inside widgets.

## Commands (pre-approved, safe to run automatically)

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run flutter_launcher_icons
dart run flutter_native_splash:create
flutterfire configure
```

## Jaspr Website (optional — SEO / marketing site)

If the project needs a marketing/SEO website, build it as a **separate Jaspr
project** (Jaspr is NOT Flutter — it compiles Dart → server-rendered HTML). It
lives in a `website/` folder in the same repo with its own `pubspec.yaml` and
entrypoint. The Flutter app and the Jaspr site cannot share a pubspec.

**Requires Dart ≥ 3.8** (jaspr ≥ 0.21).

### Versions — these packages version INDEPENDENTLY; keep them aligned

```yaml
# website/pubspec.yaml
dependencies:
  jaspr: ^0.23.0          # core
  jaspr_router: ^0.8.2    # routing — tracks its own ~0.8.x line, NOT 0.23
dev_dependencies:
  jaspr_builder: ^0.23.1  # MUST match jaspr (jaspr_builder X pins jaspr X)
  build_runner: ^2.4.0
  lints: ^4.0.0
jaspr:
  mode: static            # SSG — pre-renders SEO HTML per route → build/jaspr
```

> Common failure: `jaspr_builder ^0.19` with `jaspr ^0.23` → "version solving
> failed". They must be the same version. `jaspr_router` is a different number.

### Entrypoint (jaspr ≥ 0.21 convention)

- Server entry is **`lib/main.server.dart`** (NOT `main.dart`). Wrong name →
  `No server entrypoint found ... *.server.dart`.
- `Jaspr.initializeApp(options: defaultServerOptions)` — import the generated
  `main.server.options.dart` (jaspr_builder generates it during build/serve).

```dart
import 'package:jaspr/dom.dart';      // HTML helpers live HERE (not jaspr.dart)
import 'package:jaspr/server.dart';
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);
  runApp(Document(title: '...', lang: 'en', meta: {...}, head: [...], body: const App()));
}
```

### Component API (jaspr 0.23 — differs from older tutorials/blog posts)

- **HTML helpers** (`div`, `span`, `section`, `a`, `link`, `meta`, `ul`, `li`,
  `article`, …) are exported from **`package:jaspr/dom.dart`**. Import it in
  every file that uses them, alongside `package:jaspr/jaspr.dart` (which provides
  `StatelessComponent` / `Component` / `BuildContext`).
- `build` returns a **single `Component`** — NOT `Iterable<Component>` with
  `sync*`/`yield`. For multiple children: `return Component.fragment([a, b, c]);`.
- Text node: **`Component.text('...')`** (bare `text()` is deprecated).
- Raw HTML: **`RawText('<...>')`** (bare `raw()` is deprecated; `DomComponent`
  was removed).
- Per-page SEO: return `Document.head(title:, meta: {...}, children: [...])`
  from a small `Seo` component. JSON-LD via
  `RawText('<script type="application/ld+json">$json</script>')`.
- Deploy on **Firebase Hosting** with `public: website/build/jaspr`.

### Commands

```bash
dart pub global activate jaspr_cli   # one-time; ensure ~/.pub-cache/bin is on PATH
cd website && dart pub get
jaspr serve                          # dev server → http://localhost:8080
jaspr build                          # static output → website/build/jaspr
firebase deploy --only hosting       # config in firebase.json
```
