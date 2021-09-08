import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/home.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_input/code_input.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneRegistration extends StatefulWidget {

  String? firstName;
  String? lastName;
  String? email;
  String? password;

  PhoneRegistration({this.firstName, this.lastName, this.email,
  this.password});


  @override
  _PhoneRegistrationState createState() => _PhoneRegistrationState(
    firstName: firstName, lastName: lastName, email: email,
    password: password
  );
}

class _PhoneRegistrationState extends State<PhoneRegistration> {

  String? firstName;
  String? lastName;
  String? email;
  String? password;

  _PhoneRegistrationState({this.firstName, this.lastName, this.email,
  this.password});

  bool _isLoading = false;
  String? _loadMessage = "";


  String? _phoneCode;
  String? _phoneNumber;

  bool showCodeInput = false;
  String? _code = "+1";


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
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(loc(context, "phone_number"),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,),
                            ),
                          ),

                          Container(
                            width: 50,
                            height: 50,
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 50,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "just_one_step_away"),
                        style: TextStyle(fontWeight: FontWeight.w600,
                            color: AppColors.mediumGray, fontSize: 16),),
                    ),

                    SizedBox(height: 30,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "phone_number"),),
                    ),

                    SizedBox(height: 5,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                                ),
                                child: Material(
                                  color: Colors.white.withOpacity(0.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CountryCodePicker(

                                      onChanged: (data) {

                                        setState(() {
                                          _phoneCode = data.dialCode;
                                        });

                                      },
                                      initialSelection: 'US',
                                      favorite: ['+1'],
                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,
                                      // optional. Shows only country name and flag when popup is closed.
                                      showOnlyCountryWhenClosed: false,
                                      // optional. aligns the flag and the Text left
                                      alignLeft: false,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: loc(context, "enter_your_phone_number"),
                                      hintStyle: TextStyle(color: AppColors.mediumGray)
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {

                                    _phoneNumber = value;
                                  },
                                ),
                              )
                            ],
                          )
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
                          onTap: !showCodeInput? () {

                            AppUtilities.displayDialog(context,
                                title: loc(context, "are_u_sure"),
                                content: loc(context, "do_you_want_to_use_this_phone_number"),
                                actions: [
                                  loc(context, "cancel_uppercase"),
                                  loc(context, "yes_uppercase")
                                ],
                                callbacks: [
                                      () {
                                    Navigator.pop(context);
                                  }, () {
                                    Navigator.pop(context);
                                    verifyPhoneNumber();
                                  }
                                ]);



                          } : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              SizedBox(width: 20,),

                              Text(loc(context, "verify"), style: TextStyle( fontWeight: FontWeight.w600,
                                  color: Colors.white, fontSize: 16),),
                              SizedBox(width: 5,),
                              Icon(Icons.arrow_forward, color: Colors.white,),

                              SizedBox(width: 20,),

                            ],
                          ),
                        ),
                      ),
                    ),

                    showCodeInput? SizedBox(height: 30,) : Container(),

                    showCodeInput? Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                      child: Text(loc(context, "enter_the_code")),
                    ) : Container(),

                    showCodeInput? SizedBox(height: 5,) : Container(),

                    showCodeInput? CodeInput(
                      length: 6,
                      keyboardType: TextInputType.number,
                      builder: CodeInputBuilders.circle(border: Border.all(color: AppColors.secondary),
                          color: Colors.white, textStyle: TextStyle(color: Colors.black), totalRadius: 20),
                      spacing: 5,
                      onFilled: (value) {
                        _code = value;

                        verifyCode();
                      },
                    ) : Container(),











                  ],
                ),
              )
            ),

            _isLoading? Loader(loadMessage: _loadMessage,) : Container()
          ],
        ),
      ),
    );
  }


  void verifyCode() {

    PhoneAuthCredential credential = PhoneAuthProvider
        .credential(verificationId: verificationID as String,
        smsCode: _code as String);

    createAccount(credential);

    
  }


  String? verificationID;

  void verifyPhoneNumber() {
    var auth = FirebaseAuth.instance;

    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "verifying_phone_number")}..";
    });

    auth.verifyPhoneNumber(phoneNumber: "${_phoneCode}${_phoneNumber}",
        verificationCompleted: (credential) {


      createAccount(credential);


        },
        verificationFailed: (error) {

          Fluttertoast.showToast(
              msg: loc(context, "verification_failed"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.4),
              textColor: Colors.white.withOpacity(0.8),
              fontSize: 16.0
          );
          print("Verification failed: ${error.toString()}");
          setState(() {
            _isLoading = false;
            showCodeInput = false;
          });

        }, codeSent: (verificationID, error) {

      this.verificationID = verificationID;

          Fluttertoast.showToast(
              msg: loc(context, "code_sent"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.4),
              textColor: Colors.white.withOpacity(0.8),
              fontSize: 16.0
          );

          setState(() {
            _isLoading = false;
            showCodeInput = true;
          });

        }, codeAutoRetrievalTimeout: (error) {


          Fluttertoast.showToast(
              msg: loc(context, "code_expired"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.4),
              textColor: Colors.white.withOpacity(0.8),
              fontSize: 16.0
          );

          setState(() {
            _isLoading = false;
            showCodeInput = false;
          });
        });


  }


  void createAccount(PhoneAuthCredential credential) {
    var auth = FirebaseAuth.instance;
    var firestore = FirebaseFirestore.instance;


    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "creating_account")}..";
    });

    auth.signInWithCredential(credential).then((result1) {


      auth.createUserWithEmailAndPassword(email: email as String, password: password as String)
          .then((result) {

        String newUserID = result.user?.uid as String;

        firestore.collection(AppDatabase.users).doc(newUserID).set({
          AppDatabase.id: newUserID,
          AppDatabase.firstName: firstName,
          AppDatabase.lastName: lastName,
          AppDatabase.phoneNumber: _phoneNumber,
          AppDatabase.phoneCode: _phoneCode,
          AppDatabase.email: email,
          AppDatabase.active: false


        }).then((res) async{

          Fluttertoast.showToast(
              msg: loc(context, "account_created"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.4),
              textColor: Colors.white.withOpacity(0.8),
              fontSize: 16.0
          );



          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);


        }).catchError((onError) {
          print("Error creating account in firestore: ${onError.toString()}");

          Fluttertoast.showToast(
              msg: loc(context, "an_error_has_occurred"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.4),
              textColor: Colors.white.withOpacity(0.8),
              fontSize: 16.0
          );
        });


      }).catchError((onError) {

        print("Error creating account: ${onError.toString()}");

        Fluttertoast.showToast(
            msg: loc(context, "an_error_has_occurred"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white.withOpacity(0.8),
            fontSize: 16.0
        );

        setState(() {
          _isLoading = false;
        });

      });

    }).catchError((onError) {

      print("Error authenticating with credential: ${onError.toString()}");
      Fluttertoast.showToast(
          msg: loc(context, "an_error_has_occurred"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );

    });
  }
}
