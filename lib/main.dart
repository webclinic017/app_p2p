import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder:  (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0, ), //set desired text scale factor here
          child: child as Widget,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
          fontFamily: 'Nunito',

      ),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        AppLocalizations.delegate
      ],
      supportedLocales: [
        Locale("en"),
        Locale("es")
      ],
      home: Login(),
    );
  }
}


