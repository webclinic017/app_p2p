import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  double width;
  double height;
  String? text;
  TextStyle? textStyle;
  Color? color;
  BorderRadius? borderRadius;
  List<BoxShadow>? shadows;
  double? margin;
  Function()? onPressed;


  Button({required this.width, required this.height, this.text = "Button", this.textStyle, this.color = Colors.white,
  this.borderRadius = const BorderRadius.all(Radius.circular(10),),
    this.margin,
    this.onPressed

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin != null? EdgeInsets.fromLTRB(margin as double, 0, margin as double, 0) : EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: shadows != null? shadows : [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              spreadRadius: 1, blurRadius: 4, offset: Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPressed,
          child: Align(
            alignment: Alignment.center,
            child: Text(text as String,
            style: textStyle != null? textStyle : TextStyle(color: Colors.white,
            fontWeight: FontWeight.w600, ),),
          ),
        ),
      ),
    );
  }
}
