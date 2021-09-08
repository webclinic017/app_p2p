
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class AppUtilities {


  static void displayDialog(BuildContext context, {String? title, String? content,
  List<String>? actions, List<Function()>? callbacks}) {

    List<TextButton> buttons = [];

    for(int i = 0; i < (actions?.length as int); i ++) {
      buttons.add(TextButton(onPressed: callbacks?[i] as Function(),
        child: Text(actions?[i] as String,
        style: TextStyle(color: AppColors.primary),), ));
    }

    showDialog(context: context, builder: (context) =>
    AlertDialog(
      title: Text(title as String),
      content: Text(content as String),
      actions: buttons,

    ));

  }

  static String formatDateToTime (DateTime date) {
    return "${date.hour}:${date.minute < 10? "0${date.minute}" : date.minute}";
  }


}