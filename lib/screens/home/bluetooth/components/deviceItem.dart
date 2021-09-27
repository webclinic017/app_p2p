import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';

import 'package:flutter/material.dart';


class DeviceItem extends StatefulWidget {



  int? index;
  DeviceItem({this.index});

  @override
  _DeviceItemState createState() => _DeviceItemState(index: index);
}

class _DeviceItemState extends State<DeviceItem> {


  int? index;
  _DeviceItemState({this.index});

  bool _connecting = false;


  StreamSubscription? _btConnectionStatusListener;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
        spreadRadius: 1, blurRadius: 4, offset: Offset(0, 4))]
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async{

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("", style: TextStyle(color: Colors.black),),
              ),

              SizedBox(height: 5,),

              _connecting? Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(loc(context, "connecting"),
                style: TextStyle(fontSize: 12, color: AppColors.mediumGray),),
              ) : Container()
            ],
          ),
        ),
      )
    );
  }



}
