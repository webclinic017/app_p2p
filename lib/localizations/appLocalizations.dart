
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
      "airtven" : "AirtVen",
      "authenticating" : "Authenticating",
      "the_email_is_required" : "The email is required",
      "the_email_is_invalid" : "The email is invalid",
      "the_account_is_inactive" : "The account is inactive",
      "user_not_found" : "User not found",
      "unknown_error" : "Unknown error",
      "byubi_your_money_conversion_solution" : "Byubi, your money conversion solution",
      "tell_us_your_name" : "Tell us your name",
      "enter_your_first_name" : "Enter your first name",
      "first_name" : "First name",
      "last_name" : "Last name",
      "enter_your_last_name" : "Enter your last name",
      "continue" : "Continue",
      "phone_number" : "Phone number",
      "just_one_step_away" : "Just one step away to finish your registration",
      "enter_your_phone_number" : "Enter your phone number",
      "verify" : "Verify",
      "first_name_is_required" : "First name is required",
      "first_name_too_short" : "First name too short",
      "last_name_is_required" : "Last name is required",
      "last_name_too_short" : "Last name too short",
      "enter_the_email" : "Enter the email",
      "loading_data" : "Loading data",
      "the_entered_email_is_already_in_use" : "The entered email is already in use",
      "are_u_sure" : "Are you sure?",
      "do_you_want_to_use_this_phone_number" : "Do you want to use this phone number?",
      "cancel_uppercase" : "CANCEL",
      "yes_uppercase" : "YES",
      "verifying_phone_number" : "Verifying phone number",
      "creating_account" : "Creating account",
      "verification_failed" : "Verification failed",
      "code_sent" : "Code sent",
      "code_expired" : "Code expired",
      "enter_the_password" : "Enter the password",
      "password_is_required" : "Password is required",
      "password_too_short" : "Password to short",
      "an_error_has_occurred" : "An error has occurred",
      "enter_the_code" : "Enter the code",
      "account_created" : "Account created!",
      "new_chat" : "New Chat",
      "search_contact" : "Search contact",
      "enter_the_message" : "Enter the message",
      "byubi" : "Byubi",
      "location_services_are_disabled" : "Location services are disabled",
      "location_permissions_are_denied" : "Location permissions are denied",
      "location_permissions_are_denied_forever" : "Location permissions are denied forever, we cannot request permissions",
      "friends" : "Friends",
      "nearby" : "Nearby",
      "contacts" : "Contacts",
      "load_more_uppercase" : "LOAD MORE",
      "search_friends" : "Search friends",
      "there_are_no_friends_to_show" : "There're no friends to show",
      "search_users" : "Search users",
      "there_are_no_users_to_show" : "There are no users to show",
      "do_you_want_to_logout" : "Do you want to logout?",
      "do_you_want_to_start_a_conversation_with" : "Do you want to start a conversation with",
      "opening_chat" : "Opening chat",
      "creating_chat" : "Creating chat",
      "something_went_wrong" : "Something went wrong",
      "you_dont_have_chats_yet" : "You don't have chats yet",
      "your_balances" : "Your balances"


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
      "airtven" : "AirtVen",
      "authenticating" : "Autenticando",
      "the_email_is_required" : "El correo es requerido",
      "the_email_is_invalid" : "El correo es inválido",
      "the_account_is_inactive" : "La cuenta está inactiva",
      "user_not_found" : "Usuario no encontrado",
      "unknown_error" : "Error desconocido",
      "byubi_your_money_conversion_solution" : "Byubi, la solución de conversión de tu dinero",
      "tell_us_your_name" : "Dinos tu nombre",
      "enter_your_first_name" : "Ingresa tu nombre",
      "first_name" : "Nombre",
      "last_name" : "Apellido",
      "enter_your_last_name" : "Ingresa tu apellido",
      "continue" : "Continuar",
      "phone_number" : "Número telefónico",
      "just_one_step_away" : "A solo un paso de terminar su registro",
      "enter_your_phone_number" : "Ingresa tu número telefónico",
      "verify" : "Verificar",
      "first_name_is_required" : "El nombre es requerido",
      "first_name_too_short" : "El nombre es muy corto",
      "last_name_is_required" : "El apellido es requerido",
      "last_name_too_short" : "El apellido es muy corto",
      "enter_the_email" : "Ingresa el correo",
      "loading_data" : "Cargando datos",
      "the_entered_email_is_already_in_use" : "El correo ingresado está en uso",
      "are_u_sure" : "¿Estás seguro?",
      "do_you_want_to_use_this_phone_number" : "¿Quieres utilizar este número telefónico?",
      "cancel_uppercase" : "CANCELAR",
      "yes_uppercase" : "SÍ",
      "verifying_phone_number" : "Verificando número telefónico",
      "creating_account" : "Creando cuenta",
      "verification_failed" : "Verificación fallida",
      "code_sent" : "Código enviado",
      "code_expired" : "El código expiró",
      "enter_the_password" : "Ingresa la contraseña",
      "password_is_required" : "Password is required",
      "password_too_short" : "Password to short",
      "an_error_has_occurred" : "Ha ocurrido un error",
      "enter_the_code" : "Ingresa el código",
      "account_created" : "¡Cuenta creada!",
      "new_chat" : "Nuevo Chat",
      "search_contact" : "Buscar contacto",
      "enter_the_message" : "Ingresa el mensaje",
      "byubi" : "Byubi",
      "location_services_are_disabled" : "Los servicios de ubicación están inactivos",
      "location_permissions_are_denied" : "Los permisos de ubicación estan denegados",
      "location_permissions_are_denied_forever" : "Los permisos de ubicación estan denegados permanentemente, no podemos solicitar los permisos",
      "friends" : "Amigos",
      "nearby" : "Cercanos",
      "contacts" : "Contactos",
      "load_more_uppercase" : "CARGAR MÁS",
      "search_friends" : "Buscar amigos",
      "there_are_no_friends_to_show" : "No hay amigos para mostrar",
      "search_users" : "Buscar usuarios",
      "there_are_no_users_to_show" : "No hay más usuarios para mostrar",
      "do_you_want_to_logout" : "¿Quieres cerrar sesión?",
      "do_you_want_to_start_a_conversation_with" : "¿Quieres iniciar una conversación con",
      "opening_chat" : "Abriendo conversación",
      "creating_chat" : "Creando chat",
      "something_went_wrong" : "Algo salio mal",
      "you_dont_have_chats_yet" : "No tienes mensajes todaivia",
      "your_balances" : "Tus balances"

    }
  };

  String translate(String key) {
    return _localizedValues[locale?.languageCode]?[key] as String;
  }

}