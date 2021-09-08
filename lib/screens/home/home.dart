import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/chatsScreen.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  PageController _pageController = PageController();
  TabController? _tabController;

  int _selectedScreen = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(onPressed: () {

        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.more_vert, color: Colors.white,)),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [



            Text(loc(context, "byubi"), style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600, fontSize: 20),),
          ],
        ),
        centerTitle: true,

        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _selectedScreen = index;
            });
            _pageController.animateToPage(_selectedScreen,
                duration: Duration(milliseconds: 300), curve: Curves.ease);

          },
          tabs: [
            Tab(text: loc(context, "chats"), icon: Icon(Icons.message),),
            Tab(text: loc(context, "wallet"), icon: Icon(Icons.account_balance_wallet),),
            Tab(text: loc(context, "social"), icon: Icon(Icons.group),),
          ],
        ),

      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            child: PageView(
              controller: _pageController,
              children: [

                ChatsScreen(),
                Container(),
                Container()

              ],
            )
          )

        ],
      ),
    );
  }
}
