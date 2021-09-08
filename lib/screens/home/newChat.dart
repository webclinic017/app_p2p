import 'package:app_p2p/components/contactItem.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/newChat/contactsScreen.dart';
import 'package:app_p2p/screens/home/newChat/friendsScreen.dart';
import 'package:app_p2p/screens/home/newChat/nearbyScreen.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class NewChat extends StatefulWidget {
  const NewChat({Key? key}) : super(key: key);

  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> with SingleTickerProviderStateMixin{



  TabController? _tabController;




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
        title: Text(loc(context, "new_chat"),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: () {

          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc(context,  "friends"),),
            Tab(text: loc(context, "nearby"),),
            Tab(text: loc(context, "contacts"),)
          ],

        ),

      ),

      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: TabBarView(
              controller: _tabController,
              children: [

                FriendsScreen(),

                NearbyScreen(),

                ContactsScreen()

              ],
            )
          )
        ],
      )
    );
  }


}
