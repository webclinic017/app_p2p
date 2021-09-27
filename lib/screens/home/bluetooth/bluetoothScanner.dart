import 'dart:async';

import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/bluetooth/components/deviceItem.dart';
import 'package:app_p2p/utilities/appColors.dart';

import 'package:flutter/material.dart';


class BluetoothScanner extends StatefulWidget {
  
  

  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {


  List<Widget> _scannedDevices = [];
  List<Widget> _pairedDevices = [];

  bool _scanningDevices = false;

  List<String> _registeredID = [];



  void scanDevices() {




  }


  bool _loadingPairedDevices = false;

  void loadingPairedDevices() async{



  }

  @override
  void initState() {

    initializeBluetooth();



    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  void initializeBluetooth() async{

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "search_devices"),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(loc(context, "available_devices"),
                      style: TextStyle(fontWeight: FontWeight.w600,
                          color: AppColors.mediumGray),),
                  ),

                  SizedBox(height: 10,),

                  _scanningDevices? Column(
                    children: [

                      SizedBox(height: 20,),



                      Container(
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              child: FittedBox(
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),),
                              ),
                            ),

                            SizedBox(width: 5,),

                            Text("${loc(context, "scanning_devices")}..")

                          ],
                        ),
                      )

                    ],
                  ) : Column(
                    children: _scannedDevices,
                  ),

                  SizedBox(height: 40,),


                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(loc(context, "paired_devices"),
                      style: TextStyle(fontWeight: FontWeight.w600,
                          color: AppColors.mediumGray),),
                  ),

                  SizedBox(height: 10,),

                  _loadingPairedDevices? Column(
                    children: [

                      SizedBox(height: 20,),



                      Container(
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              child: FittedBox(
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),),
                              ),
                            ),

                            SizedBox(width: 5,),

                            Text("${loc(context, "loading_paired_devices")}..")

                          ],
                        ),
                      )

                    ],
                  ) : Column(
                    children: _pairedDevices,
                  )

                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
