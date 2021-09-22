
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
      "your_balances" : "Your balances",
      "available_balances" : "Available balances",

      "united_states_dollar" : "United States dollar",
      "euro" : "Euro",
      "russian_ruble" : "Russian Ruble",
      "british_pound_sterling" : "British Pound Sterling",
      "yuan" : "Yuan",
      "japanese_yen" : "Japanese Yen",
      "singapore_dollar" : "Singapore Dollar",
      "indian_rupee" : "Indian Rupee",
      "swiss_franc" : "Swiss Franc",
      "australian_dollar" : "Australian Dollar",
      "canadian_dollar" : "Canadian Dollar",
      "hong_kong_dollar" : "Hong kong dollar",
      "malaysian_ringgit" : "Malaysian Ringgit",
      "norwegian_krone" : "Norwegian Krone",
      "new_zealand_dollar" : "New Zealand Dollar",
      "south_african_rand" : "South African Rand",
      "swedish_krona" : "Swedish Krona",
      "danish_krone" : "Danish Krone",
      "brazilian_real" : "Brazilian Real",
      "south_african_cents" : "South African Cents",
      "mexican_peso" : "Mexican Peso",
      "new_taiwan_dollar" : "New Taiwan Dollar",
      "south_korean_won" : "South Korean Won",
      "chilean_peso" : "Chilean Peso",
      "czech_koruna" : "Czech Koruna",
      "hungarian_forint" : "Hugarian Forint",
      "indonesian_rupiah" : "Indonesian Rupiah",
      "icelandic_krona" : "Icelandic Krona",
      "mexican_peso_to_inversion" : "Mexican Peso to Inversion",
      "polish_zloty" : "Polish Zloty",
      "turkish_lira" : "Turkish Lira",
      "uruguayan_peso" : "Uruguayan Peso",
      "fiat_currencies" : "Fiat Currencies",
      "b_dollars" : "B-Dollars",
      "cryptocurrencies" : "Cryptocurrencies",
      "assets" : "Assets",
      "fiat" : "Fiat",
      "crypto" : "Crypto",

      "Australian Dollar Futures" : "Australian Dollar Futures",
      "British Pound Futures" : "British Pound Futures",
      "Canadian Dollar Futures" : "Canadian Dollar Futures",
      "Euro FX Futures" : "Euro FX Futures",
      "Japanese Yen Futures" : "Japanese Yen Futures",
      "Brazilian Real Futures" : "Brazilian Real Futures",
      "New Zealand Dollar Futures" : "New Zealand Dollar Futures",
      "Russian Ruble Futures" : "Russian Ruble Futures",
      "Swiss Franc Futures" : "Swiss Franc Futures",
      "South African Rand Futures" : "South African Rand Futures",
      "Bitcoin Futures CME" : "Bitcoin Futures CME",
      "Soybean Oil" : "Soybean Oil",
      "Brent Crude" : "Brent Crude",
      "CAC 40 Futures" : "CAC 40 Futures",
      "Cash-settled Butter Futures" : "Cash-settled Butter Futures",
      "Cocoa" : "Cocoa",
      "Carbon Emissions Futures" : "Carbon Emissions Futures",
      "Canada Government Bond 10Y Futures" : "Canada Government Bond 10Y Futures",
      "Crude Oil" : "Crude Oil",
      "Cotton" : "Cotton",
      "DAX Futures" : "DAX Futures",
      "Class III Milk Futures" : "Class III Milk Futures",
      "Dow Jones Futures" : "Dow Jones Futures",
      "Dollar Index Future" : "Dollar Index Future",
      "Dry Whey Futures" : "Dry Whey Futures",
      "EH" : "EH",
      "E-Mini S&P 500" : "E-Mini S&P 500",
      "Feeder Cattle Futures" : "Feeder Cattle Futures",
      "Euro Bund Futures" : "Euro Bund Futures",
      "Euro BOBL Futures" : "Euro BOBL Futures",
      "Euro SCHATZ Futures" : "Euro SCHATZ Futures",
      "MSCI Emerging Markets Equity Futures" : "MSCI Emerging Markets Equity Futures",
      "VSTOXX Mini Futures" : "VSTOXX Mini Futures",
      "US 5 Year T-Note Contract" : "US 5 Year T-Note Contract",
      "Gold" : "Gold",
      "Class IV Milk Futures" : "Class IV Milk Futures",
      "Eurodollar Futures" : "Eurodollar Futures",
      "Feeder Cattle Futures" : "Feeder Cattle Futures",
      "Copper" : "Copper",
      "NY Harbor ULSD Futures" : "NY Harbor ULSD Futures",
      "US Midwest Domestic Hot-Rolled Coil Steel Futures" : 'US Midwest Domestic Hot-Rolled Coil Steel Futures',
      "Hang Seng Index Futures" : "Hang Seng Index Futures",
      "Hang Seng Tech Index Futures" : "Hang Seng Tech Index Futures",
      "IBEX Futures" : "IBEX Futures",
      "FTSE MIB Futures" : "FTSE MIB Futures",
      "Coffee" : "Coffee",
      "Lumber" : "Lumber",
      "ICE Brent Crude" : "ICE Brent Crude",
      "Live Cattle Futures" : "Live Cattle Futures",
      "Lean Hogs" : "Lean Hogs",
      "Aluminum" : "Aluminum",
      "currencies_and_assets" : "Currencies & Assets",
      "balance" : "Balance",
      "open_balance_uppercase" : "OPEN BALANCE",
      "in_b_dollars" : "In B-Dollars",
      "convert_balance" : "Convert Balance",
      "from" : "From",
      "to" : "To",
      "convert_uppercase" : "CONVERT",
      "balance_picker" : "Balance Picker",
      "do_you_want_to_open_a_new" : "Do you want to open a new",
      "balance_lowercase" : "balance",
      "balance_opened" : "Balance opened",
      "opening_balance" : "Opening balance",
      "do_you_want_to_convert" : "Do you want to convert",
      "into_lowercase" : "into",
      "converting" : "Converting",
      "conversion_performed" : "Conversion performed",
      "send_money" : 'Send money',
      "receive_money" : "Receive money",
      "add_funds" : "Add Funds",
      "method" : "Method",
      "checkout" : "Checkout",
      "mobile_payment" : "Pago Móvil",
      "international_card" : "Tarjeta Internacional",
      "cryptocurrency" : "Cryptocurrency",
      "methods_uppercase" : "METHODS",
      "which_method_do_you_want_to_use_to_add_funds" : "Which method do you want to use to add funds?",
      "balance_uppercase" : "BALANCE",
      "select_the_balance_where_do_you_want_to_add_money" : "Select the balance where do you want to add money",
      "previous" : "Previous",
      "checkout_uppercase" : "CHECKOUT",
      "just_a_few_steps_left_and_we_will_be_ready" : "Just a few steps left and we will be ready",
      "payment_method" : "Payment method",
      "continue_to_payment_uppercase" : "CONTINUE TO PAYMENT",
      "the_amount_must_be_greater_than_zero" : "The amount must be greater than zero",
      "amount" : "Amount",
      "processing_request" : "Processing request"





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
      "your_balances" : "Tus balances",
      "available_balances" : "Balances disponibles",

      "united_states_dollar" : "Dolar estadunidense",
      "euro" : "Euro",
      "russian_ruble" : "Rublo Ruso",
      "british_pound_sterling" : "Libra Esterlina",
      "yuan" : "Yuan",
      "japanese_yen" : "Yen Japonés",
      "singapore_dollar" : "Dólar de Singapore",
      "indian_rupee" : "Rupia India",
      "swiss_franc" : "Franco Suizo",
      "australian_dollar" : "Dólar Autraliano",
      "canadian_dollar" : "Dólar Canadiense",
      "hong_kong_dollar" : "Dólar de Hong Kong",
      "malaysian_ringgit" : "Ringgit Malayo",
      "norwegian_krone" : "Corona Noruega",
      "new_zealand_dollar" : "Dolar de Nueva Zelanda",
      "south_african_rand" : "Rand sudafricana",
      "swedish_krona" : "Corona suecaa",
      "danish_krone" : "Corona Danesa",
      "brazilian_real" : "Real Brasileño",
      "south_african_cents" : "Centavos sudafricanos",
      "mexican_peso" : "Peso Mexicano",
      "new_taiwan_dollar" : "Nuevo Dólar Taiwanés",
      "south_korean_won" : "Won Surcoreano",
      "chilean_peso" : "Peso Chileno",
      "czech_koruna" : "Corona Checa",
      "hungarian_forint" : "Florín Húngaro",
      "indonesian_rupiah" : "Rupia Indonesia",
      "icelandic_krona" : "Corona Islandesa",
      "mexican_peso_to_inversion" : "Unidad De Inversión Mexicana",
      "polish_zloty" : "Zloty Polaco",
      "turkish_lira" : "Lira Turca",
      "uruguayan_peso" : "Peso Uruguayo",
      "fiat_currencies" : "Monedas Fiat",
      "b_dollars" : "B-dólares",
      "cryptocurrencies" : "Criptomonedas",
      "assets" : "Assets",
      "fiat" : "Fiat",
      "crypto" : "Crypto",

      "Australian Dollar Futures" : "Futuros del dólar australiano",
      "British Pound Futures" : "Futuros de la libra esterlina",
      "Canadian Dollar Futures" : "Futuros del dólar canadiense",
      "Euro FX Futures" : "Futuros Euro FX",
      "Japanese Yen Futures" : "Futuros del yen japonés",
      "Brazilian Real Futures" : "Futuros reales brasileños",
      "New Zealand Dollar Futures" : "Futuros del dólar neozelandés",
      "Russian Ruble Futures" : "Futuros del rublo ruso",
      "Swiss Franc Futures" : "Futuros del franco suizo",
      "South African Rand Futures" : "Futuros del rand sudafricano",
      "Bitcoin Futures CME" : "Futuros de Bitcoin CME",
      "Soybean Oil" : "Aceite de soja",
      "Brent Crude" : "Brent crudo",
      "CAC 40 Futures" : "Futuros CAC 40",
      "Cash-settled Butter Futures" : "Futuros de mantequilla liquidados en efectivo",
      "Cocoa" : "Cacao",
      "Carbon Emissions Futures" : "Futuros de emisiones de carbono",
      "Canada Government Bond 10Y Futures" : "Futuros de bonos del gobierno de Canadá a 10 años",
      "Crude Oil" : "Petróleo crudo",
      "Cotton" : "Algodón",
      "DAX Futures" : "Futuros DAX",
      "Class III Milk Futures" : "Futuros de leche de clase III",
      "Dow Jones Futures" : "Futuros Dow Jones",
      "Dollar Index Future" : "Futuro del índice del dólar",
      "Dry Whey Futures" : "Futuros de suero seco",
      "EH" : "EH",
      "E-Mini S&P 500" : "E-Mini S&P 500",
      "Feeder Cattle Futures" : "Futuros de ganado de engorde",
      "Euro Bund Futures" : "Futuros sobre bonos en euros",
      "Euro BOBL Futures" : "Futuros Euro BOBL",
      "Euro SCHATZ Futures" : "Futuros Euro SCHATZ",
      "MSCI Emerging Markets Equity Futures" : "Futuros de acciones de mercados emergentes de MSCI",
      "VSTOXX Mini Futures" : "Mini Futuros VSTOXX",
      "US 5 Year T-Note Contract" : "Contrato de T-Note a 5 años de EE. UU.",
      "Gold" : "Oro",
      "Class IV Milk Futures" : "Futuros de leche de clase IV",
      "Eurodollar Futures" : "Futuros de eurodólares",
      "Feeder Cattle Futures" : "Futuros de ganado de engorde",
      "Copper" : "Cobre",
      "NY Harbor ULSD Futures" : "Futuros de ULSD del puerto de Nueva York",
      "US Midwest Domestic Hot-Rolled Coil Steel Futures" : 'Futuros de acero en bobina laminada en caliente nacional del medio oeste de EE. UU.',
      "Hang Seng Index Futures" : "Futuros del índice Hang Seng",
      "Hang Seng Tech Index Futures" : "Futuros del índice Hang Seng Tech",
      "IBEX Futures" : "Futuros IBEX",
      "FTSE MIB Futures" : "Futuros FTSE MIB",
      "Coffee" : "Café",
      "Lumber" : "Tablas de madera",
      "ICE Brent Crude" : "ICE Brent crudo",
      "Live Cattle Futures" : "Futuros de ganado vivo",
      "Lean Hogs" : "Cerdos magros",
      "Aluminum" : "Aluminio",
      "currencies_and_assets" : "Monedas Y Activos",
      "open_balance_uppercase" : "ABRIR BALANCE",
      "in_b_dollars" : "En B-Dollars",
      "convert_balance" : "Convertir Balance",
      "from" : "Desde",
      "to" : "A",
      "convert_uppercase" : "CONVERTIR",
      "balance_picker" : "Selector de Balances",
      "do_you_want_to_open_a_new" : "¿Quieres abrir un nuevo",
      "balance_lowercase" : "balance?",
      "balance_opened" : "Balance abierto",
      "opening_balance" : "Abriendo balance",
      "do_you_want_to_convert" : "¿Quieres convertir",
      "into_lowercase" : "en",
      "converting" : "Convirtiendo",
      "conversion_performed" : "Conversión realizada",
      "send_money" : 'Enviar dinero',
      "receive_money" : "Recibir dinero",
      "add_funds" : "Agregar fondos",
      "checkout" : "Verificar",
      "mobile_payment" : "Pago Móvil",
      "international_card" : "Tarjeta Internacional",
      "cryptocurrency" : "Criptomonedas",
      "methods_uppercase" : "MÉTODOS",
      "which_method_do_you_want_to_use_to_add_funds" : "¿Qué metodo quieres utilizar para agregar fondos?",
      "select_the_balance_where_do_you_want_to_add_money" : "Selecciona el balance donde quieres agregar dinero",
      "previous" : "Anterior",
      "checkout_uppercase" : "REVISION",
      "just_a_few_steps_left_and_we_will_be_ready" : "Solo unos pocos pasos más y estaremos listos",
      "payment_method" : "Payment method",
      "continue_to_payment_uppercase" : "IR AL PAGAR",
      "the_amount_must_be_greater_than_zero" : "El monto tiene que ser mayor a cero",
      "amount" : "Monto",
      "processing_request" : "Procesando solicitud"




    }
  };

  String translate(String key) {
    return _localizedValues[locale?.languageCode]?[key] as String;
  }

}