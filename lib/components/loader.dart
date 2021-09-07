import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {

  String? isLoading;
  String? loadMessage;

  Loader({this.isLoading, this.loadMessage});


  @override
  _LoaderState createState() => _LoaderState(
    isLoading: isLoading, loadMessage: loadMessage
  );
}

class _LoaderState extends State<Loader> {

  String? isLoading;
  String? loadMessage;

  _LoaderState({this.isLoading, this.loadMessage});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5)
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),

          Container(
            width: double.infinity,
            height: 80,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
              spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
            ),
            child: Row(
              children: [
                SizedBox(width: 20,),

                Container(
                  width: 40,
                  height: 40,
                  child: FittedBox(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),),
                  ),
                ),

                SizedBox(width: 10,),

                Text(loadMessage as String),


                SizedBox(width: 20,),

              ],
            ),
          ),

          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }
}
