import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/home.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

String? userID = "user1";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [


            Transform.translate(offset: Offset(MediaQuery.of(context).size.width/2 + 40, -50),
            child: Image.asset("assets/coin.png", width: 200, height: 200,),),

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
                              fontSize: 12)
                          ),
                          style: TextStyle(fontSize: 12),
                          onChanged: (value) {

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
                                  fontSize: 12)
                              ),
                              style: TextStyle(fontSize: 12),
                              onChanged: (value) {

                              },
                            ),
                          ),

                          Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              child: Text(loc(context, "forgot"), style: TextStyle(fontWeight: FontWeight.w600,
                              color: AppColors.primary, fontSize: 12),),
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

                                  Navigator.push(context, MaterialPageRoute(builder:(context) => Home()));

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    SizedBox(width: 20,),

                                    Text(loc(context, "login"), style: TextStyle( fontWeight: FontWeight.w600,
                                    color: Colors.white),),
                                    SizedBox(width: 5,),
                                    Icon(Icons.arrow_forward, color: Colors.white,),

                                    SizedBox(width: 20,),

                                  ],
                                ),
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

            )




          ],
        ),
      ),
    );
  }
}
