import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MethodButton extends StatelessWidget {

  
  String? method;
  Function()? onPressed;
  MethodButton({this.method, this.onPressed});
  
  
  Image get buttonImage {
    
    if(method == AppDatabase.mobilePayment) {
      return Image.asset("assets/mobile_payment.png", width: 60, height: 60,);
    }else if(method == AppDatabase.internationalCard) {
      return Image.asset("assets/card_payment.png", width: 60, height: 60,);
      
    }else if(method == AppDatabase.cryptocurrency) {
      return Image.asset("assets/crypto_payment.png", width: 60, height: 60,);
    }

    return Image.asset("assets/mobile_payment.png", width: 60, height: 60,);
    
  }

  String buttonText(BuildContext context) {
    if(method == AppDatabase.mobilePayment) {
      return loc(context, "mobile_payment");
    }else if(method == AppDatabase.internationalCard) {
      return loc(context, "international_card");

    }else if(method == AppDatabase.cryptocurrency) {
      return loc(context, "cryptocurrency");
    }

    return loc(context, "mobile_payment");
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
        spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onPressed?.call();
          },
          child: Row(
            children: [

              SizedBox(width: 10,),

              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(10)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: buttonImage,
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: Text(buttonText(context), style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w600),),
              )
              
              
            ],
          ),
        ),
      ),
    );
  }
}

