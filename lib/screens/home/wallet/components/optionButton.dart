import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {

  IconData? icon;
  String? text;
  Function()? onPressed;

  OptionButton({this.icon, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              SizedBox(width: 20,),

              Icon(icon),
              SizedBox(width: 5,),

              Expanded(
                child: Text(text as String, ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


