import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{
  static const String themeKey='isDarkMode';
  // static const String fontSizeKey='font_size';

  //Save a theme preference
  Future<void> setTheme(bool isDarkMode)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDarkMode);
  }

  Future<bool> getTheme()async{
    final prefs=await SharedPreferences.getInstance();
   return  prefs.getBool(themeKey)??false;
  }


}
