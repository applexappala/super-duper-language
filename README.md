# super_duper_language

A new Flutter project.

## Premium Tech Stack
- **Architecture**: Clean Architecture (Presentation, Domain, Data)
- **State Management**: [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
- **Dependency Injection**: [Get It](https://pub.dev/packages/get_it) + [Injectable](https://pub.dev/packages/injectable)
- **UI Framework**: [Shadcn UI](https://mariuti.com/flutter-shadcn-ui/)
- **Responsiveness**: [Responsive Framework](https://pub.dev/packages/responsive_framework) (Mobile, Tablet, Desktop, 4K)
- **Feedback**: [Flutter EasyLoading](https://pub.dev/packages/flutter_easyloading) (Standardized for all loading/errors)
- **Animations**: [Animations](https://pub.dev/packages/animations)
- **Firebase**: Integrated for Crashlytics, Remote Config, and App Check.

## Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Setup Firebase**:
   Run `flutterfire configure` to generate Firebase options and setup project correctly.

3. **Code Generation** (Models & DI):
   ```bash
   # Run this whenever you add @injectable or @freezed classes
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Assets Generation**:
   ```bash
   # Generate Launcher Icons
   dart run flutter_launcher_icons
   
   # Generate Splash Screen
   dart run flutter_native_splash:create
   ```

## Development Guidelines
This project uses custom instructions located in `.github/instructions/instructions.md`.
AI tools working on this project are configured to:
- Use **shadcn_ui** for all components.
- Use **EasyLoading** for all service indicators.
- **NEVER** use `MediaQuery` for layout logic (use `ResponsiveBreakpoints` instead).
- Follow Clean Architecture with Bloc.
