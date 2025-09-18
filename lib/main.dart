import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/auth.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_feed/helpers/providers/auth_providers.dart';
import 'package:social_feed/helpers/riverpod/auth.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HiveService.registerAdapters();
  await HiveService.openBox<HiveUserModel>('userbox');
  await HiveService.openBox<String>('tokens');
  runApp(ProviderScope(child: MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure AuthController is created (starts auto-refresh)
    ref.read(authControllerProvider);

    // Attach lifecycle observer (to re-check tokens when resuming)
    useEffect(() {
      final observer = _LifecycleObserver(() {
        ref
            .read(checkAccessTokenProvider.future)
            .catchError((e) => print("Error checking token on resume: $e"));
      });
      WidgetsBinding.instance.addObserver(observer);
      return () => WidgetsBinding.instance.removeObserver(observer);
    }, []);

    // Run token check on startup
    useEffect(() {
      Future.microtask(() async {
        try {
          await ref.read(checkAccessTokenProvider.future);
        } catch (e) {
          print("Error checking token on startup: $e");
        }
      });
      return null;
    }, []);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Social Feed App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
      builder: (context, child) {
        return _AuthStateListener(child: child!);
      },
    );
  }
}

/// Listens for auth state changes and redirects to login when needed
class _AuthStateListener extends ConsumerWidget {
  final Widget child;
  const _AuthStateListener({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<HiveUserModel>>>(authStateProvider, (
      prev,
      next,
    ) {
      next.whenOrNull(
        data: (users) {
          if (users.isEmpty) {
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const Login()),
              (_) => false,
            );
          }
        },
        error: (_, __) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const Login()),
            (_) => false,
          );
        },
      );
    });

    return child;
  }
}

/// Observer that calls a callback whenever app resumes
class _LifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResume;
  _LifecycleObserver(this.onResume);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
    super.didChangeAppLifecycleState(state);
  }
}
