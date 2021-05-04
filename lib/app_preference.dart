import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/model.dart';

class AppPreference {
  static const _keyGarments = 'garmentsKey';

  static Future<SharedPreferences> _getPref() {
    return SharedPreferences.getInstance();
  }

  static Future<List<Garment>> getGarments() async {
    String jsonString = (await _getPref()).getString(_keyGarments);
    return Garment.getList(jsonString != null ? json.decode(jsonString) : null);
  }

  static Future<bool> setGarments(List<Garment> list) async {
    String jsonString;
    if (list != null && list.isNotEmpty)
      jsonString = json.encode(Garment.getJsonList(list));
    final pref = await _getPref();
    if (jsonString == null)
      return pref.remove(_keyGarments);
    else
      return pref.setString(_keyGarments, jsonString);
  }
}
