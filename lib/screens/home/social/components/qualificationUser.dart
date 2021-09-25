import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QualificationUser extends StatefulWidget {

  UserData? data;
  Function(UserData)? onUserRated;
  QualificationUser({this.data, this.onUserRated});

  @override
  _QualificationUserState createState() => _QualificationUserState(data: data,
  onUserRated: onUserRated);
}

class _QualificationUserState extends State<QualificationUser> {
  UserData? data;
  Function(UserData)? onUserRated;
  _QualificationUserState({this.data, this.onUserRated});

  @override
  void initState() {

    loadUserImage();
    super.initState();
  }

  Image? _userImage;

  void loadUserImage () {

    if(data?.imageUrl != null) {
      setState(() {
        _userImage = Image.network(data?.imageUrl as String, width: 80,
        height: 80, fit: BoxFit.cover,);
      });
    }
  }



  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
        spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
      ),
      child: Column(
        children: [
          SizedBox(height: 30,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            height: 80,
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.form,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _userImage != null? _userImage : Container(),
                  ),
                )
              ],
            )
          ),

          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text("${data?.firstName} ${data?.lastName}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
          ),

          SizedBox(height: 10,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text("${data?.phoneCode} ${data?.phoneNumber}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
              color: AppColors.mediumGray),
            ),
          ),

          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child:  Text(loc(context, "rating"),)
          ),

          SizedBox(height: 5,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow,),
                SizedBox(width: 5,),
                Text(data?.rating?.toStringAsFixed(1) as String,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                  color: Colors.yellow),)
              ],
            )

          ),

          SizedBox(height: 10,),

          Container(
            width: double.infinity,
            height: 25,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Row(
              children: [
                Material(
                  color: Colors.white.withOpacity(0.0),
                  child: InkWell(
                    onTap: () {

                      seeComments();

                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(loc(context, "see_comments"),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.secondary),),
                    ),
                  ),
                )
              ],
            )
          ),

          SizedBox(height: 50,),


          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(loc(context,"rate_user_uppercase")),
          ),

          SizedBox(height: 10,),

          !_applyingRating? Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Align(
              alignment: Alignment.center,
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 10,
                itemSize: 20,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {

                  setState(() {
                    _rating = rating;
                  });
                  AppUtilities.displayDialog(context, title: loc(context, "are_u_sure"),
                      content: "${loc(context, "do_you_want_to_rate_this_user_with")} ${_rating} ${loc(context, "stars_question")}",
                      actions: [loc(context, "cancel_uppercase"),
                        loc(context, "rate_uppercase")],
                      callbacks: [() {
                        Navigator.pop(context);
                      }, () {
                        Navigator.pop(context);
                        rate();
                      }]);
                  print(rating);
                },
              ),
            )
          ) : Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),),
              ),
            ),
          ),


          SizedBox(height: 50,),




        ],
      ),
    );
  }

  void seeComments () {

  }


  bool _applyingRating = false;
  void rate () {
    var firestore = FirebaseFirestore.instance;
    setState(() {
      _applyingRating = true;
    });


    firestore.runTransaction((transaction) async {

      var userRef = firestore.collection(AppDatabase.users).doc(data?.id);
      var userDoc = await transaction.get(userRef);

      double currentRating = 0.0;
      try {
        currentRating = double.parse(userDoc.data()?[AppDatabase.rating].toString() as String);
      }catch(e) {
        currentRating = 0.0;
      }

     double ratingCount = 0;

      try {
        ratingCount = double.parse(userDoc.data()?[AppDatabase.ratingCount].toString() as String);
      }catch(e) {
        ratingCount = 0;
      }




      var newRatingRef = firestore.collection(AppDatabase.users).doc(data?.id)
      .collection(AppDatabase.ratings).doc(data?.id);

      var ratingDoc = await transaction.get(newRatingRef);


      int ratingSessions = 0;

      try {
        ratingSessions = int.parse(ratingDoc.data()?[AppDatabase.ratingSessions].toString() as String);
      }catch(e) {
        ratingSessions = 0;
      }

      double lastRating = 0.0;

      try {
        lastRating = double.parse(ratingDoc.data()?[AppDatabase.lastRating].toString() as String);
      }catch(e) {
        lastRating = 0.0;
      }

      double newRating = 0.0;

      double resultRating = currentRating;


      if(ratingSessions > 0) {

        newRating = (lastRating + _rating) / 2.0;
        resultRating = ((currentRating * ratingCount) - lastRating + newRating) / ratingCount;

        print("Result rating regular: ${ratingCount}");
      }else {

        newRating = _rating;

        ratingCount ++;

        if(ratingCount > 1) {
          resultRating = (currentRating + _rating) / 2.0;
        }else {
          resultRating = _rating;
        }

        print("Result rating first session: ${ratingCount}");




      }

      ratingSessions ++;


      transaction.set(newRatingRef, {
        AppDatabase.ratingSessions: ratingSessions,
        AppDatabase.lastRating: newRating
      });

      var ratingTransaction = firestore.collection(AppDatabase.users).doc(data?.id)
          .collection(AppDatabase.ratings).doc(data?.id)
      .collection(AppDatabase.ratingsHistory).doc();

      transaction.set(ratingTransaction, {
        AppDatabase.rating: _rating,
        AppDatabase.ratingNumber: ratingSessions,
        AppDatabase.created: DateTime.now(),
      });

      transaction.update(userRef, {
        AppDatabase.ratingCount: ratingCount,
        AppDatabase.rating: resultRating
      });







    }).then((result) {

      setState(() {
        _applyingRating = false;
      });

      Fluttertoast.showToast(
          msg: "${loc(context, "user_rated")}!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );

      onUserRated?.call(data as UserData);

    }).catchError((onError) {

      setState(() {
        _applyingRating = false;
      });

      print("Error rating user: ${onError.toString()}");

    });
  }
}
