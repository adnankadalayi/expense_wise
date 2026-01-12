import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class StorageService extends GetxService {
  late Isar db;

  Future<StorageService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [], // Add schemas here later
      directory: dir.path,
    );
    return this;
  }
}
