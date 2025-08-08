import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_feed/pages/comments.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/pages/new_post.dart';
import 'package:social_feed/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await HiveService.initHiveBoxes();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Feed App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Comments(postId: "1"),
    );
  }
}
