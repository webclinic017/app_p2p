import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';
class RatingPanel extends StatefulWidget {

  double? rating;
  Function(String)? onRateSent;
  Function()? onBack;

  RatingPanel({this.rating, this.onRateSent, this.onBack});

  @override
  _RatingPanelState createState() => _RatingPanelState(
    rating: rating, onRateSent: onRateSent, onBack: onBack
  );
}

class _RatingPanelState extends State<RatingPanel> {

  double? rating;
  Function(String)? onRateSent;
  Function()? onBack;
  _RatingPanelState({this.rating, this.onRateSent, this.onBack});

  String comment = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5)
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          onTap: () {
            onBack?.call();
          },
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1, blurRadius: 4, offset: Offset(0, 4))]
                ),
                child: Column(
                  children: [

                    SizedBox(height: 30,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(loc(context, "your_new_rating")),

                    ),

                    SizedBox(height: 5,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("${rating?.toStringAsFixed(1)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
                            color: Colors.orange),),

                    ),

                    SizedBox(height: 20,),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(loc(context, "comment")),
                    ),

                    SizedBox(height: 5,),

                    Container(
                      width: double.infinity,
                      height: 120,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          color: AppColors.form,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: loc(context, "enter_the_comment"),
                              hintStyle: TextStyle(color: AppColors.mediumGray)
                          ),
                          onChanged: (value) {
                            setState(() {
                              comment = value;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),

                    comment.length > 3?Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
                              spreadRadius: 1,blurRadius: 4, offset: Offset(0, 4))]
                      ),
                      child: Material(
                        color: Colors.white.withOpacity(0.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {

                            onRateSent?.call(comment);
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(loc(context, "send_rate_uppercase"),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                  color: Colors.white),),
                          ),
                        ),
                      ),
                    ) : Container(),


                    SizedBox(height: 30,),


                  ],
                ),
              ),

              Expanded(
                child: Container(),
              )
            ],
          ),
        ),
      )
    );
  }
}
