import 'package:app_p2p/database/friendData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class FriendItem extends StatefulWidget {

  FriendData? data;
  Function(FriendData)? onPressed;
  FriendItem({this.data});

  @override
  _FriendItemState createState() => _FriendItemState(data: data,
  onPressed: onPressed);
}

class _FriendItemState extends State<FriendItem> {

  FriendData? data;
  Function(FriendData)? onPressed;
  _FriendItemState({this.data, this.onPressed});

  UserData? _friendUserData;

  void loadFriendUserData () async{

    _friendUserData = await UserData.fromID(data?.userID as String);

    setState(() {

    });

    loadFriendImage();
  }

  Image? _friendImage;

  void loadFriendImage () {

    if(_friendUserData?.imageUrl != null) {
      setState(() {
        _friendImage = Image.network(_friendUserData?.imageUrl as String,
        width: 50, height: 50,);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
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
            onPressed?.call(data as FriendData);
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
                  child: _friendImage != null? _friendImage : Container(),
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      width: double.infinity,
                      child: Text(_friendUserData != null? "${_friendUserData?.firstName} ${_friendUserData?.lastName}" : "-",
                      style: TextStyle(fontWeight: FontWeight.w600),),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      width: double.infinity,
                      child: Text(_friendUserData != null? "${_friendUserData?.phoneCode} ${_friendUserData?.phoneNumber}" : "-",
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
