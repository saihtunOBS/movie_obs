

import 'package:get_storage/get_storage.dart';

enum PersistenceList { loginUser, locale, isFirstTime, token, userData, tenant }

class PersistenceData {
  static var shared = PersistenceData();

  saveFirstTime(bool? isFirstTime) async {
    await GetStorage().write(PersistenceList.isFirstTime.name, isFirstTime);
  }

  saveToken(String token) async {
    await GetStorage().write(PersistenceList.token.name, token);
  }

  saveLocale(String locale) async {
    await GetStorage().write(PersistenceList.locale.name, locale);
  }


  /// get...

  getFirstTimeStatus() {
    return GetStorage().read(PersistenceList.isFirstTime.name);
  }

  getToken() {
    return GetStorage().read(PersistenceList.token.name);
  }



  getLocale() {
    return GetStorage().read(PersistenceList.locale.name) ?? 'en';
  }

  clearToken() async {
    saveToken('');
    await GetStorage().remove(PersistenceList.token.name);
  }

  clearUserData() {
    GetStorage().remove(PersistenceList.userData.name);
  }
}