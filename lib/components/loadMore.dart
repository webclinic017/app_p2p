import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';
class LoadMore extends StatefulWidget {

  Function()? onLoad;
  LoadMore({this.onLoad});

  @override
  _LoadMoreState createState() => _LoadMoreState(onLoad: onLoad);
}

class _LoadMoreState extends State<LoadMore> {

  Function()? onLoad;
  _LoadMoreState({this.onLoad});

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          onTap: () {

            onLoad?.call();
          },
          child: Align(
            alignment: Alignment.center,
            child: !_isLoading? Text(loc(context, "load_more_uppercase")) :
            Container(
              width: 30,
              height: 30,
              child: FittedBox(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),),
              ),
            ),
          ),
        ),
      ),

    );
  }
}
