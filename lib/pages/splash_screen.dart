import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/pages/home.dart';
import 'package:social_feed/pages/login.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hive boxes are guaranteed open now
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final tokensBox = HiveService.getBox<String>('tokens');

    final user = userBox.get('user');
    final accessToken = tokensBox.get('accessToken');

    if (user == null || accessToken == null) {
      return const Login();
    }

    return const Home();
  }
}
