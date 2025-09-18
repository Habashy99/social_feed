import 'package:hive/hive.dart';
import 'package:social_feed/models/user.dart';

class HiveService {
  static void registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveUserModelAdapter());
    }
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  // make getBox async
  static Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw HiveError("Box '$boxName' is not open. Call openBox first!");
    }
    return Hive.box<T>(boxName);
  }
}
