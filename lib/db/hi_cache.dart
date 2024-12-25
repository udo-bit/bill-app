import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  SharedPreferences? preferences;
  HiCache._() {
    init();
  }

  HiCache._pre(SharedPreferences prefs) {
    preferences = prefs;
  }

  static HiCache? _instance;
  static HiCache getInstance() {
    _instance ??= HiCache._();
    return _instance!;
  }

  void init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  setString(String key, String value) {
    preferences?.setString(key, value);
  }

  setDouble(String key, double value) {
    preferences?.setDouble(key, value);
  }

  setInt(String key, int value) {
    preferences?.setInt(key, value);
  }

  setStringList(String key, List<String> value) {
    preferences?.setStringList(key, value);
  }

  remove(String key) {
    preferences?.remove(key);
  }

  T? get<T>(String key) {
    var result = preferences?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
