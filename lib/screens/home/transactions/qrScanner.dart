import 'dart:io';

import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {

  Function(UserData, BalanceData)? onUserFound;
  QrScanner({this.onUserFound});

  @override
  _QrScannerState createState() => _QrScannerState(onUserFound: onUserFound);
}

class _QrScannerState extends State<QrScanner> {

  Function(UserData, BalanceData)? onUserFound;

  _QrScannerState({this.onUserFound});

  bool _isLoading = false;
  String _loadMessage = "";

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  QRViewController? controller;

  bool _scanningUser = false;

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [

                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      children: [
                        IconButton(onPressed: () {

                          Navigator.pop(context);

                        }, icon: Icon(Icons.arrow_back_ios)),

                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(loc(context, "qr_scanner"),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                          ),
                        ),

                        Container(
                          width: 50,
                          height: 50,
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 40,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "scan_the_qr_code")),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "scan_the_code_of_the_user_you_want_to_send_funds"),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppColors.mediumGray),),
                  ),

                  SizedBox(height: 40,),

                  Expanded(
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: (QRViewController controller) {
                        this.controller = controller;

                        controller.scannedDataStream.listen((event) {


                          if(!_scanningUser) {
                            findUser(event.code);
                          }



                        });
                      },
                    ),
                  ),




                ],
              ),
            ),

            _isLoading? Loader(loadMessage: _loadMessage,) : Container()
          ],
        ),
      ),
    );
  }


  void findUser (String code) {

    String uID = code.split("-")[0];
    String walletID = code.split("-")[1];

    setState(() {
      _isLoading = true;
      _scanningUser = true;
      _loadMessage = "${loc(context, "identifying_user")}..";
    });


    var firestore = FirebaseFirestore.instance;
    firestore.collection(AppDatabase.users).doc(uID).get().then((doc) {

      if(doc.data() == null) {
        Fluttertoast.showToast(
            msg: loc(context, "invalid_user"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white.withOpacity(0.8),
            fontSize: 16.0
        );
        return;
      }else {

        firestore.collection(AppDatabase.users).doc(uID)
        .collection(AppDatabase.balances).doc(walletID).get().then((doc2) {


          UserData userData = UserData.fromDoc(doc);
          BalanceData balanceData = BalanceData.fromDoc(doc2);

          onUserFound?.call(userData, balanceData);
          Navigator.pop(context);

        }).catchError((onError) {
          setState(() {
            _isLoading = false;
            _scanningUser = false;
          });
          Fluttertoast.showToast(
              msg: loc(context, "en_error_has_occurred"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.4),
              textColor: Colors.white.withOpacity(0.8),
              fontSize: 16.0
          );

          print("Error searching balance: ${onError.toString()}");
        });





      }




    }).catchError((onError) {

      setState(() {
        _isLoading = false;
        _scanningUser = false;
      });
      Fluttertoast.showToast(
          msg: loc(context, "en_error_has_occurred"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );

      print("Error searching user: ${onError.toString()}");

    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
