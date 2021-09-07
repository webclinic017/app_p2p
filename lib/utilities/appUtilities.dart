
class AppUtilities {



  static String formatDateToTime (DateTime date) {
    return "${date.hour}:${date.minute < 10? "0${date.minute}" : date.minute}";
  }
}