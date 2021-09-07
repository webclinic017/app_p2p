import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class PhoneRegistration extends StatefulWidget {



  @override
  _PhoneRegistrationState createState() => _PhoneRegistrationState();
}

class _PhoneRegistrationState extends State<PhoneRegistration> {


  String? _phoneCode;
  String? _phoneNumber;

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
                        onTap: () {

                          verifyPhoneNumber();

                        },
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









                ],
              ),
            )
          ],
        ),
      ),
    );
  }



  void verifyPhoneNumber() {

  }
}
