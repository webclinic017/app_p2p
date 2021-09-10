
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


  static List<String> generateKeywords (String base) {
    List<String> result = [];
    List<String> splits = base.toLowerCase().split(" ");
    List<String> savedWords = [];
    int currentIndex = 0;

    for(int i = 0; i < splits.length; i ++) {
      for(int j = 0; j <= splits[i].length; j ++) {
        result.add(splits[i].substring(0, j));


      }

    }


    for(int i = 0; i < splits.length; i ++) {
      for(int j = 0; j <= splits[i].length; j ++) {
        result.add((savedWords.length > 0? savedWords[currentIndex] + " ": "")  +  splits[i].substring(0, j));


        if(j == splits[i].length) {

          if(savedWords.length > 0) {
            currentIndex ++;
          }


          savedWords.add(splits[i].substring(0, j));
        }



      }

    }

    result.removeWhere((element) => element == "");
    result.removeWhere((element) => element == " ");

    result.toSet().toList();

    print("Base: $base,  KeywordsResult: $result");
    return result;

  }


}