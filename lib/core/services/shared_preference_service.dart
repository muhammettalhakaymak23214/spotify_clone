import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferences? _prefs;

  //Init
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int getindex() {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    return _prefs!.getInt("index") ?? 1;
  }

  //Set Oto Loop
  static Future<bool> setOtoindex(int index) async {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    await _prefs!.setInt("index", index);
    debugPrint("true");
    return true;
  }

  //Get Oto Loop
  static bool getOtoLoop() {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    return _prefs!.getBool("otoLoop") ?? false;
  }

  //Set Oto Loop
  static Future<bool> setOtoLoop() async {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    final tempOtoLoop = _prefs!.getBool("otoLoop") ?? false;
    await _prefs!.setBool("otoLoop", !tempOtoLoop);
    await _prefs!.setBool("otoNext", false);
    debugPrint("true");
    return true;
  }

  //Get Oto Next
  static bool getOtoNext() {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    return _prefs!.getBool("otoNext") ?? false;
  }

  //Set Oto Next
  static Future<bool> setOtoNext() async {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    final tempOtoNext = _prefs!.getBool("otoNext") ?? false;
    await _prefs!.setBool("otoNext", !tempOtoNext);
    await _prefs!.setBool("otoLoop", false);
    return true;
  }

  //Get Oto Mode
  static bool getOtoMode() {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    return _prefs!.getBool("otoMode") ?? false;
  }

  //Set Oto Mode
  static Future<bool> setOtoMode() async {
    if (_prefs == null) {
      throw Exception('[SharedPreferenceService] : Not initialized');
    }
    final tempOtoMode = _prefs!.getBool("otoMode") ?? false;
    await _prefs!.setBool("otoMode", !tempOtoMode);
    return true;
  }
}
