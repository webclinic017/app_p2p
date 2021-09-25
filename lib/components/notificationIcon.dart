import 'package:flutter/material.dart';


class NotificationIcon extends StatelessWidget {

  int? unseenCount;
  Function()? onPressed;
  NotificationIcon({this.unseenCount, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed: () {

          onPressed?.call();

        }, icon: Icon(Icons.notifications, color: Colors.white,)),

        (unseenCount as int) > 0?IgnorePointer(
          child: Container(
              width: 50,
              height: 50,

              child: Transform.translate(offset: Offset(-15, 15),
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("${unseenCount}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                          color: Colors.white),),
                    ),
                  )
              )
          ),
        ) : Container()
      ],
    );
  }
}


