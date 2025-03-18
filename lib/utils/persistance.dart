import 'package:get_storage/get_storage.dart';

enum PersistenceList { second, locale, isFirstTime, token, userData, tenant }

class PersistenceData {
  static var shared = PersistenceData();

  saveSecond(int? second) async {
    await GetStorage().write(PersistenceList.second.name, second);
  }

  getSecond() async {
    await GetStorage().remove(PersistenceList.second.name);
  }

  clearUserData() {
    GetStorage().remove(PersistenceList.userData.name);
  }
}
