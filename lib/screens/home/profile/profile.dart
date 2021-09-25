
import 'dart:io';
import 'dart:math';

import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {



  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _isLoading = false;
  String _loadMessage = "";


  Image? _currentImage;

  void loadUserImage() {

    if(currentUserData != null) {
      if(currentUserData?.imageUrl != null) {
        setState(() {
          _currentImage = Image.network(currentUserData?.imageUrl as String,
          width: 150, height: 150, fit: BoxFit.cover,);
        });
      }
    }
  }


  @override
  void initState() {
    loadUserImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "profile"),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: () {

          Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [

                SizedBox(height: 40,),

                Container(
                  width: double.infinity,
                  height: 150,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.form,
                        shape: BoxShape.circle
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: _currentImage != null? _currentImage : Container(),
                      ),
                    )
                  ),
                ),

                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  height: 25,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Material(
                    color: Colors.white.withOpacity(0.0),
                    child: InkWell(
                      child: Text(loc(context, "change_picture"),
                      textAlign: TextAlign.center,),
                      onTap: () {

                        changePicture();
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "first_name"), style: TextStyle(fontSize: 12),),

                ),
                SizedBox(height: 5,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(currentUserData?.firstName as String,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                ),

                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "last_name"), style: TextStyle(fontSize: 12),),

                ),
                SizedBox(height: 5,),


                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(currentUserData?.lastName as String,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                  ),),
                ),

                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(loc(context, "phone_number"), style: TextStyle(fontSize: 12),),

                ),
                SizedBox(height: 5,),


                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text("${currentUserData?.phoneCode} ${currentUserData?.phoneNumber}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                      color: AppColors.mediumGray
                    ),),
                ),

                SizedBox(height: 50,),

                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                  ),
                  child: Material(
                    color: Colors.white.withOpacity(0.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {

                        AppUtilities.displayDialog(context, title: loc(context, "are_u_sure"),
                            content: loc(context, "do_you_want_to_logout"),
                            actions: [loc(context, "cancel_uppercase"),
                              loc(context, "yes_uppercase")],
                            callbacks: [() {

                              Navigator.pop(context);

                            }, () {

                              Navigator.pop(context);
                              logout();
                            }]);


                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(loc(context, "close_session_uppercase"),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                              color: Colors.white), textAlign: TextAlign.center,),
                      )
                    ),
                  ),
                )


              ],
            ),
          )



        ],
      ),
    );
  }



  void changePicture () async{
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    updateImage(image?.path as String);

  }


  void updateImage(String filePath) async{
    var storage = FirebaseStorage.instance.ref();
    var firestore = FirebaseFirestore.instance;

    File imageFile = File(filePath);

    if(currentUserData?.imagePath != null) {
      await storage.child(currentUserData?.imagePath as String).delete();
    }

    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "uploading_picture")}...";
    });

    int number = Random().nextInt(99999);

    String imagePath = "${AppDatabase.users}/${userID}/${number}_profilePic.png";

    storage.child(imagePath).putFile(imageFile).then((result) async{


      setState(() {
        _isLoading = false;
      });
      String url = await result.ref.getDownloadURL();

      firestore.collection(AppDatabase.users).doc(userID).update({
        AppDatabase.imageUrl: url,
        AppDatabase.imagePath: imagePath
      }).then((result2) {

        Fluttertoast.showToast(
            msg: loc(context, "picture_uploaded"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white.withOpacity(0.8),
            fontSize: 16.0
        );


        updateData(imagePath);


      }).catchError((onError) {

        print("Error updating data in database: ${onError.toString()}");

        setState(() {
          _currentImage = null;
        });


      });



    }).catchError((onError) {

      setState(() {
        _isLoading = false;
      });

      print("Error uploading picture: ${onError.toString()}");

    });
  }

  void updateData(String imagePath) async{
    var storage = FirebaseStorage.instance.ref();

   String url = await storage.child(imagePath).getDownloadURL();

   setState(() {
     currentUserData?.imagePath = imagePath;
     currentUserData?.imageUrl = url;
   });

   loadUserImage();
  }

  void logout() {
    var auth = FirebaseAuth.instance;

    auth.signOut().then((result) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);

    }).catchError((onError) {

      print("Error loging out: ${onError.toString()}");
    });


  }
}
