import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/home.dart';
import 'package:app_p2p/screens/home/wallet/addFunds/components/addFundsCaller.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';


class AddFundsCheckout extends StatefulWidget {


  AddFundsCaller? caller;
  Function()? onBack;

  AddFundsCheckout({this.caller, this.onBack});

  @override
  _AddFundsCheckoutState createState() => _AddFundsCheckoutState(
    caller: caller, onBack: onBack
  );
}

class _AddFundsCheckoutState extends State<AddFundsCheckout> {

  AddFundsCaller? caller;
  Function()? onBack;

  _AddFundsCheckoutState({this.caller, this.onBack});


  Image get buttonImage {

    if(caller?.paymentMethod == AppDatabase.mobilePayment) {
      return Image.asset("assets/mobile_payment.png", width: 60, height: 60,);
    }else if(caller?.paymentMethod == AppDatabase.internationalCard) {
      return Image.asset("assets/card_payment.png", width: 60, height: 60,);

    }else if(caller?.paymentMethod == AppDatabase.cryptocurrency) {
      return Image.asset("assets/crypto_payment.png", width: 60, height: 60,);
    }

    return Image.asset("assets/mobile_payment.png", width: 60, height: 60,);

  }

  String buttonText(BuildContext context) {
    if(caller?.paymentMethod == AppDatabase.mobilePayment) {
      return loc(context, "mobile_payment");
    }else if(caller?.paymentMethod == AppDatabase.internationalCard) {
      return loc(context, "international_card");

    }else if(caller?.paymentMethod == AppDatabase.cryptocurrency) {
      return loc(context, "cryptocurrency");
    }

    return loc(context, "mobile_payment");
  }

  double _amount = 0.0;



  bool _isLoading = false;
  String _loadMessage = "";

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

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "checkout_uppercase"),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                ),
                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "just_a_few_steps_left_and_we_will_be_ready"),
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.mediumGray),),
                ),

                SizedBox(height: 30,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "payment_method")),
                ),
                SizedBox(height: 5,),

                Container(
                  width: double.infinity,
                  height: 60,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Row(
                    children: [
                      SizedBox(width: 10,),

                      Container(
                        width: 40,
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: buttonImage,
                        ),
                      ),

                      SizedBox(width: 5,),

                      Text(buttonText(context))
                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "balance")),
                ),

                SizedBox(height: 5,),

                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: BalanceItem(data: caller?.balanceData, ),
                ),

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "amount")),
                ),

                SizedBox(height: 5,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                      color: AppColors.form,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffix: Text("${caller?.balanceData?.currencyCode?.substring(0, 3)}")
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        try {
                          _amount = double.parse(value.toString());
                        }catch(e) {
                          _amount = 0.0;
                        }

                        setState(() {

                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 5,),


                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text("${caller?.balanceData?.isFiat == true? _amount * (1.0/(caller?.exchangeData?.close as double)) : (_amount * (caller?.exchangeData?.close as double))} B-Dollars",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.mediumGray),),
                ),




                SizedBox(height: 40,),

                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child: Material(
                    color: Colors.white.withOpacity(0.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async{

                        if(_amount == 0) {
                          Fluttertoast.showToast(
                              msg: loc(context, "the_amount_must_be_greater_than_zero"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black.withOpacity(0.4),
                              textColor: Colors.white.withOpacity(0.8),
                              fontSize: 16.0
                          );
                          return;
                        }


                        if(caller?.paymentMethod == AppDatabase.internationalCard) {

                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
                          launch("https://byubi-69a43.web.app/checkout?userID=${userID}&name=${"${currentUserData?.firstName} ${currentUserData?.lastName}"}&amount=${_amount}&rate=${caller?.balanceData?.isFiat == true? (1.0/(caller?.exchangeData?.close as double)) : (caller?.exchangeData?.close as double)}&balanceID=${caller?.balanceData?.id}");

                        }else if(caller?.paymentMethod == AppDatabase.cryptocurrency) {

                          setState(() {
                            _isLoading = true;
                            _loadMessage = "${loc(context, "processing_request")}..";
                          });

                          try {
                            var response = await Dio().post("https://cuidabu.herokuapp.com/pay-with-crypto-byubi", data: {
                              "amount" : _amount,
                              "name" : "${currentUserData?.firstName} ${currentUserData?.lastName}",
                              "rate" : caller?.balanceData?.isFiat == true? (1.0/(caller?.exchangeData?.close as double)) : (caller?.exchangeData?.close as double),
                              "userID" : userID
                            });

                            String hostedUrl = response.data["charge"]["hosted_url"];
                            print("Hosted url: ${response.data["charge"]["hosted_url"]}");

                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
                            launch(hostedUrl);


                          }catch(e) {

                            setState(() {
                              _isLoading = false;
                            });
                            print("Error adding funds: ${e.toString()}");
                          }
                        }




                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(loc(context, "continue_to_payment_uppercase"),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Row(
                    children: [
                      Container(
                          height: 50,
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                onBack?.call();
                              },
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Text(loc(context, "previous"),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                        color: AppColors.secondary),),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40,),



              ],
            ),
          )
        ),

        _isLoading? Loader(loadMessage: _loadMessage,) : Container()
      ],
    );
  }



}
