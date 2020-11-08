import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  SharedPreferences mPrefs;

  write(String key, dynamic value) async {
    mPrefs = await SharedPreferences.getInstance();
    final raw = json.encode(value);
    return mPrefs.setString(key, raw);
  }

  read(String key) async {
    mPrefs = await SharedPreferences.getInstance();
    final raw = mPrefs.getString(key);
    if (raw == null) return null;
    final value = json.decode(raw);
    return value;
  }

  delete(String key) async {
    mPrefs = await SharedPreferences.getInstance();
    return mPrefs.remove(key);
  }

  deleteAllData() async {
    mPrefs = await SharedPreferences.getInstance();
    return mPrefs.clear();
  }
}
