import 'package:isar_community/isar.dart';

part 'settings.g.dart';

@collection
class Settings {
  Id id = Isar.autoIncrement;

  bool darkMode = false;
  bool dailyReminders = true;
  bool cloudBackup = true;
}
