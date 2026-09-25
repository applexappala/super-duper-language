import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:super_duper_language/core/di/injection.dart';
import 'package:super_duper_language/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  configureDependencies();
  
  // Setup EasyLoading
  configLoading();

  // Initialize Firebase (Requires flutterfire configure first)
  // try {
  //   await Firebase.initializeApp();
  // } catch (e) {
  //   debugPrint('Firebase initialization failed: $e');
  // }

  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color(0xFFF8FAFC)
    ..backgroundColor = const Color(0xFF0F172A)
    ..indicatorColor = const Color(0xFFF8FAFC)
    ..textColor = const Color(0xFFF8FAFC)
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'super_duper_language',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      builder: (context, child) {
        // Integrate EasyLoading and Responsive Framework
        child = ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: 'MOBILE'),
            const Breakpoint(start: 451, end: 800, name: 'TABLET'),
            const Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
        return FlutterEasyLoading(child: child);
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to super_duper_language',
              style: ShadTheme.of(context).textTheme.h1,
            ),
            const SizedBox(height: 20),
            ShadButton(
              onPressed: () {
                EasyLoading.show(status: 'Loading from Shadcn UI...');
                Future.delayed(const Duration(seconds: 2), () {
                  EasyLoading.dismiss();
                  ShadToaster.of(context).show(
                    const ShadToast(
                      description: Text('Successfully initialized with Shadcn UI!'),
                    ),
                  );
                });
              },
              child: const Text('Test Loading & Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
