import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ar_AE.dart';
import 'en_us.dart';

class LocalizationService extends Translations {
  static final locale =locales.first;

  static final fallBackLocale = Locale("ar", "AE");

  static final langs = ['عربي', 'English'];

  static final locales = [Locale("ar", "AE"), Locale("en", "US")];
  static var selectedLang = langs.first.obs;

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_AE': arAE,
  };

  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    selectedLang.value = lang;
    Get.updateLocale(locale);
  }

  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}