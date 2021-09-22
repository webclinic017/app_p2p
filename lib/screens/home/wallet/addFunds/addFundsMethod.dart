import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/wallet/addFunds/components/methodButton.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class AddFundsMethod extends StatefulWidget {

  Function(String)? onMethodSelected;
  AddFundsMethod({this.onMethodSelected});

  @override
  _AddFundsMethodState createState() => _AddFundsMethodState(
    onMethodSelected: onMethodSelected
  );
}

class _AddFundsMethodState extends State<AddFundsMethod> {

  Function(String)? onMethodSelected;
  _AddFundsMethodState({this.onMethodSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "methods_uppercase"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                ),

                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "which_method_do_you_want_to_use_to_add_funds"),
                  style: TextStyle(color: AppColors.mediumGray, ),),
                ),

                SizedBox(height: 30,),


                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: MethodButton(method: AppDatabase.mobilePayment, onPressed: () {

                    onMethodSelected?.call(AppDatabase.mobilePayment);

                  },),
                ),

                SizedBox(height: 15,),

                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: MethodButton(method: AppDatabase.internationalCard, onPressed: () {

                    onMethodSelected?.call(AppDatabase.internationalCard);

                  },),
                ),

                SizedBox(height: 15,),

                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: MethodButton(method: AppDatabase.cryptocurrency, onPressed: () {

                    onMethodSelected?.call(AppDatabase.cryptocurrency);

                  },),
                )


              ],
            ),
          ),
        )


      ],
    );
  }
}
