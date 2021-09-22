import 'package:app_p2p/screens/home/wallet/components/completionIndicatorController.dart';
import 'package:flutter/material.dart';

class CompletionIndicatorViewPage extends StatefulWidget {

  CompletionIndicatorController? controller;
  List<Widget>? children;
  CompletionIndicatorViewPage({@required this.controller, @required this.children});


  @override
  _CompletionIndicatorViewPageState createState() => _CompletionIndicatorViewPageState(controller: controller,
  children: children);
}

class _CompletionIndicatorViewPageState extends State<CompletionIndicatorViewPage> {

  CompletionIndicatorController? controller;
  List<Widget>? children;
  _CompletionIndicatorViewPageState({this.controller, this.children});

  PageController? _pageController = PageController(initialPage: 0);

  @override
  void initState() {

    controller?.subscribe((index) {

      _pageController?.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: children as List<Widget>,
    );
  }
}
