import 'package:hive/hive.dart';
import '../models/user.dart';

class HiveService {
  static const _boxName = 'userbox';

  static Future<void> initHiveBoxes() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveUserModelAdapter());
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<HiveUserModel>(_boxName);
    }
  }

  static Box<HiveUserModel> getUserBox() {
    return Hive.box<HiveUserModel>(_boxName);
  }
}
