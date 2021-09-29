import 'dart:async';

import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/bluetooth/components/bluetoothDeviceEntryList.dart';
import 'package:app_p2p/screens/home/bluetooth/components/deviceItem.dart';
import 'package:app_p2p/utilities/appColors.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';



class BluetoothScanner extends StatefulWidget {
  

  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {




  late StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = [];

  bool isDiscovering = true;


  @override
  void initState() {

    _startDiscovery();

    super.initState();
  }


  void _startDiscovery () {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            results.add(r);
          });
        });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription.cancel();

    super.dispose();
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
            child:Column(
              children: [

                SizedBox(height: 50,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(loc(context, "available_devices"),
                    style: TextStyle(fontWeight: FontWeight.w600,
                        color: AppColors.mediumGray),),
                ),

                SizedBox(height: 10,),

                isDiscovering? Column(
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
                ) : Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, index) {
                      BluetoothDiscoveryResult result = results[index];
                      return BluetoothDeviceListEntry(
                        device: result.device,
                        rssi: result.rssi,
                        onTap: () {
                          Navigator.of(context).pop(result.device);
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 40,),




              ],
            ),
          )
        ],
      ),
    );
  }
}
