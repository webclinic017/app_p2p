import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/home.dart';
import 'package:app_p2p/screens/register/register.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String? userID = "user1";
UserData? currentUserData;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  String? _email;
  String? _password;

  bool _isLoading = false;
  String _loadMessage = "";


  bool _autoLogin = false;
  void autoLogin() async{
    var auth = FirebaseAuth.instance;
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _autoLogin = true;
    });

    if(auth.currentUser != null) {
      userID = auth.currentUser?.uid;

      if(currentUserData == null) {
        var userDoc = await firestore.collection(AppDatabase.users).doc(userID).get();
        currentUserData = UserData.fromDoc(userDoc);
      }

      setState(() {
        _autoLogin = false;
      });
      loadHome();

    }else {

      setState(() {
        _autoLogin = false;
      });

    }



  }

  @override
  void initState() {

    Future.delayed(Duration(milliseconds: 500), () {
      autoLogin();
    });
    super.initState();
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


                    Expanded(child: Container(),),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "login"), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                    ),

                    SizedBox(height: 5,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(loc(context, "please_login_to_continue"), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.mediumGray),),
                    ),

                    SizedBox(height: 40,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1, blurRadius: 6, offset: Offset(0, 2))
                        ]
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: loc(context, "email"),
                              hintStyle: TextStyle(color: AppColors.mediumGray,
                              )
                          ),
                          onChanged: (value) {

                            _email = value;

                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1, blurRadius: 6, offset: Offset(0, 2))
                          ]
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: loc(context, "password"),
                                  hintStyle: TextStyle(color: AppColors.mediumGray,
                                  )
                              ),
                              onChanged: (value) {

                                _password = value;
                              },
                            ),
                          ),

                          Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              child: Text(loc(context, "forgot"), style: TextStyle(fontWeight: FontWeight.w600,
                              color: AppColors.primary, ),),
                            ),
                          )
                        ],
                      )
                    ),

                    SizedBox(height: 40,),

                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary,
                                  AppColors.accent
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

                                  login();

                                },
                                child: !_autoLogin? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    SizedBox(width: 20,),

                                    Text(loc(context, "login"), style: TextStyle( fontWeight: FontWeight.w600,
                                    color: Colors.white, fontSize: 16),),
                                    SizedBox(width: 5,),
                                    Icon(Icons.arrow_forward, color: Colors.white,),

                                    SizedBox(width: 20,),

                                  ],
                                ) : Row(
                                  children: [
                                    SizedBox(width: 20,),
                                    FittedBox(
                                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                    ),
                                    SizedBox(width: 20,),
                                  ],
                                )
                              ),
                            ),
                          )

                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(loc(context, "dont_have_an_account"), style: TextStyle(fontWeight: FontWeight.w600,
                          color: AppColors.mediumGray),),

                          SizedBox(width: 5,),

                          Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {

                                loadRegister();

                              },
                              child: Text(loc(context, "register"), style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 30,)



                  ],
                ),

            ),

            _isLoading? Loader(loadMessage: _loadMessage,) : Container()




          ],
        ),
      ),
    );
  }

  void loadRegister() {

    Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
  }



  void login() {
    var auth = FirebaseAuth.instance;
    var firestore = FirebaseFirestore.instance;




    if(_email == null) {

      Fluttertoast.showToast(
          msg: loc(context,  "the_email_is_required"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }else if((_email?.length as int) < 10) {
      Fluttertoast.showToast(
          msg: loc(context,  "the_email_is_invalid"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }


    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "authenticating")}..";
    });

    auth.signInWithEmailAndPassword(email: _email as String, password: _password as String)
    .then((result) {

      userID = result.user?.uid;

      firestore.collection(AppDatabase.users).doc(userID).get().then((doc) {

        currentUserData = UserData.fromDoc(doc);

        if(currentUserData?.active == false) {
          Fluttertoast.showToast(
              msg: loc(context,  "the_account_is_inactive"),
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
          return;
        }

        loadHome();

      }).catchError((onError) {

        print("Error loading user data: ${onError.toString()}");

        setState(() {
          _isLoading = false;
        });

      });



    }).catchError((onError) {

      setState(() {
        _isLoading = false;
      });

      if(onError.toString().contains(AppDatabase.userNotFound)) {
        Fluttertoast.showToast(
            msg: loc(context,  "user_not_found"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white.withOpacity(0.8),
            fontSize: 16.0
        );
      }else {
        Fluttertoast.showToast(
            msg: loc(context,  "unknown_error"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white.withOpacity(0.8),
            fontSize: 16.0
        );
      }

      print("Error authenticating user: ${onError.toString()}");
    });




  }


  void loadHome () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
}
