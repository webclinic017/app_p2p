import 'package:app_p2p/screens/home/wallet/components/completionIndicatorController.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class CompletionIndicator extends StatefulWidget {



  int? pagesCount;
  Color? backgroundColor;
  Color? indicatorColor;
  Function(int)? onChange;
  CompletionIndicatorController? controller;

  CompletionIndicator({@required this.pagesCount, this.backgroundColor = const Color.fromRGBO(230, 230, 230, 1.0), this.indicatorColor = Colors.blue, this.onChange,
  this.controller});

  @override
  _CompletionIndicatorState createState() => _CompletionIndicatorState(
    pagesCount: pagesCount, onChange: onChange, backgroundColor: backgroundColor,
    indicatorColor: indicatorColor, controller: controller
  );
}

class _CompletionIndicatorState extends State<CompletionIndicator> {

  int? pagesCount;
  Color? backgroundColor;
  Color? indicatorColor;
  Function(int)? onChange;
  CompletionIndicatorController? controller;

  _CompletionIndicatorState({this.pagesCount, this.backgroundColor,
    this.indicatorColor, this.onChange, this.controller});

  List<Widget> _dots = [];

  int _currentIndex = 0;

  @override
  void initState() {

    generateIndicator();

    controller?.subscribe((index) {

      if(_currentIndex != index) {
        _currentIndex = index;
        onChange?.call(index);
        generateIndicator();
      }

    });



    super.initState();
  }


  void next () {

    if(_currentIndex < (pagesCount as int) - 1) {
      _currentIndex ++;
      controller?.call(_currentIndex);
      onChange?.call(_currentIndex);
      generateIndicator();
    }

  }

  void back() {

    if(_currentIndex > 0) {
      _currentIndex --;
      controller?.call(_currentIndex);
      onChange?.call(_currentIndex);
      generateIndicator();
    }
  }

  void generateIndicator () {

    setState(() {
      _dots.clear();
    });
    for(int i = 0; i < (pagesCount as int); i ++) {

      if(_currentIndex == i) {
        _dots.add(Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle
          ),

        ));
      }else {
        _dots.add(Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle
          ),

        ));
      }


      if(i < (pagesCount as int) - 1) {

        _dots.add(Expanded(child: Container(),));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25,
      child: Row(
        children: [

        ],
      ),
    );
  }
}

