
import 'package:app_p2p/localizations/appLocalizationsDelegate.dart';
import 'package:flutter/material.dart';

String loc(BuildContext context, String key) {
  return AppLocalizations.of(context)?.translate(key) as String;
}

class AppLocalizations {

  Locale? locale;

  AppLocalizations(this.locale);



  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static  List<String> languages() => ["en", "es"];

  static AppLocalizationsDelegate get delegate => AppLocalizationsDelegate();

  Map<String, Map<String, String>> _localizedValues = {
    "en" : {
      "login" : "Login",
      "please_login_to_continue" : "Please login to continue",
      "email" : "Email",
      "password" : "Password",
      "forgot" : "Forgot",
      "dont_have_an_account" : "Don't have an account?",
      "register" : "Register",
      "chats" : "Chats",
      "wallet" : "Wallet",
      "social" : "Social",
      "airtven" : "AirtVen"
    },

    "es" : {
      "login" : "Inicar Sesión",
      "please_login_to_continue" : "Por favor inica sesión para continuar",
      "email" : "Correo",
      "password" : "Contraseña",
      "forgot" : "La Olvidé",
      "dont_have_an_account" : "¿No tienes una cuenta?",
      "register" : "Registrarse",
      "chats" : "Chats",
      "wallet" : "Cartera",
      "social" : "Social",
      "airtven" : "AirtVen"
    }
  };

  String translate(String key) {
    return _localizedValues[locale?.languageCode]?[key] as String;
  }

}