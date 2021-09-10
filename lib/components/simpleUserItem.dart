import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';
class SimpleUserItem extends StatefulWidget {

  UserData? data;
  Function(UserData)? onPressed;
  SimpleUserItem({this.data, this.onPressed});

  @override
  _SimpleUserItemState createState() => _SimpleUserItemState(
    data: data, onPressed: onPressed
  );
}

class _SimpleUserItemState extends State<SimpleUserItem> {

  UserData? data;
  Function(UserData)? onPressed;
  _SimpleUserItemState({this.data, this.onPressed});

  Image? _userImage;

  void loadUserImage() {

    if(data?.imageUrl != null) {
      setState(() {
        _userImage = Image.network(data?.imageUrl as String,
        width: 50, height: 50,);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              onPressed?.call(data as UserData);
            },
            child: Row(
              children: [
                SizedBox(width: 10,),

                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.form,
                      shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _userImage != null? _userImage : Container(),
                  ),
                ),

                SizedBox(width: 10,),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        width: double.infinity,
                        child: Text(data != null? "${data?.firstName} ${data?.lastName}" : "-",
                          style: TextStyle(fontWeight: FontWeight.w600),),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: double.infinity,
                        child: Text(data != null? "${data?.phoneCode} ${data?.phoneNumber}" : "-",
                          style: TextStyle(fontSize: 12, color: AppColors.mediumGray),),
                      ),

                    ],
                  ),
                ),
                SizedBox(width: 10,),




              ],
            ),
          ),
        )
    );
  }
}
