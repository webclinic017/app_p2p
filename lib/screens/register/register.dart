import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/register/phoneRegistration.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {


  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isLoading = false;
  String? _loadMessage = "";


  String? _firstName;
  String? _lastName;
  String? _email;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: [
                          IconButton(onPressed: () {

                            Navigator.pop(context);

                          }, icon: Icon(Icons.arrow_back_ios)),

                          Expanded(
                              child: Container()
                          )
                        ],
                      ),
                    ),



                    SizedBox(height: 50,),



                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "byubi_your_money_conversion_solution",),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                        textAlign: TextAlign.center,),
                    ),

                    SizedBox(height: 30,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "register"),
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600,),),
                    ),

                    SizedBox(height: 10,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "tell_us_your_name"),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                            color: AppColors.mediumGray),),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "first_name"),),
                    ),

                    SizedBox(height: 5,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: loc(context, "enter_your_first_name"),
                              hintStyle: TextStyle(color: AppColors.mediumGray)
                          ),
                          onChanged: (value) {

                            _firstName = value;
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "last_name"),),
                    ),

                    SizedBox(height: 5,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: loc(context, "enter_your_last_name"),
                              hintStyle: TextStyle(color: AppColors.mediumGray)
                          ),
                          onChanged: (value) {

                            _lastName = value;
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "email"),),
                    ),

                    SizedBox(height: 5,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: loc(context, "enter_the_email"),
                              hintStyle: TextStyle(color: AppColors.mediumGray)
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {

                            _email = value;
                          },
                        ),
                      ),
                    ),


                    SizedBox(height: 40,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondary,
                              AppColors.primary
                            ],
                          ),
                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3),
                              spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4)),
                            BoxShadow(color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                      ),
                      child: Material(
                        color: Colors.white.withOpacity(0.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {

                            continueRegistration();

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              SizedBox(width: 20,),

                              Text(loc(context, "continue"), style: TextStyle( fontWeight: FontWeight.w600,
                                  color: Colors.white, fontSize: 16),),
                              SizedBox(width: 5,),
                              Icon(Icons.arrow_forward, color: Colors.white,),

                              SizedBox(width: 20,),

                            ],
                          ),
                        ),
                      ),
                    ),





                  ],
                ),
              ),
            ),

            _isLoading? Loader(loadMessage: _loadMessage,) : Container()

          ],
        ),
      ),
    );
  }

  void continueRegistration() {
    var firestore = FirebaseFirestore.instance;


    if(_firstName == null) {
      Fluttertoast.showToast(
          msg: loc(context, "first_name_is_required"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }else if((_firstName?.length as int) < 3) {
      Fluttertoast.showToast(
          msg: loc(context, "first_name_too_short"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }

    if(_lastName == null) {
      Fluttertoast.showToast(
          msg: loc(context, "last_name_is_required"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }else if((_lastName?.length as int) < 3) {
      Fluttertoast.showToast(
          msg: loc(context, "last_name_too_short"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }


    if(_email == null) {
      Fluttertoast.showToast(
          msg: loc(context, "the_email_is_required"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }else if((_email?.length as int) < 10) {
      Fluttertoast.showToast(
          msg: loc(context, "the_email_is_invalid"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "loading_data")}..";
    });


    firestore.collection(AppDatabase.users).where(AppDatabase.email,
    isEqualTo: _email).get().then((query) {
      setState(() {
        _isLoading = false;
      });

      if(query.docs.length > 0) {
        Fluttertoast.showToast(
            msg: loc(context, "the_entered_email_is_already_in_use"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white.withOpacity(0.8),
            fontSize: 16.0
        );

        return;
      }


      continueToPhoneRegistration();

    }).catchError((onError) {

      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: loc(context, "unknown_error"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      print("Error checking the email: ${onError.toString()}");
    });

  }


  void continueToPhoneRegistration () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneRegistration()));
  }


}
