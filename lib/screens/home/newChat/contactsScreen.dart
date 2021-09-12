import 'package:app_p2p/components/contactItem.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
class ContactsScreen extends StatefulWidget {


  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

bool _loadingContacts = false;

List<Widget> _contactsItems = [];

String? _searchQuery;

List<Contact> contacts = [];
bool _rendererState = false;


void loadContacts() async{

  if(await FlutterContacts.requestPermission()) {

    setState(() {
      _loadingContacts = true;
    });



    contacts = await FlutterContacts.getContacts(withPhoto: true,
      withProperties: true, );

    for(Contact c in contacts) {
      setState(() {
        _contactsItems.add(ContactItem(contact: c,));
        _contactsItems.add(SizedBox(height: 10,));
      });

     // print("Contact loaded: ${c.name}");

    }

    setState(() {
      _loadingContacts = false;
    });
  }

}

@override
  void initState() {
  loadContacts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: loc(context, "search_contact"),
                          hintStyle: TextStyle(color: AppColors.mediumGray)
                      ),
                      onChanged: (value) {

                        _searchQuery = value;
                        setState(() {
                          _searchResult = false;
                        });

                      },
                      onFieldSubmitted: (value) {
                        _searchQuery = value;
                        searchContacts();
                      },
                    ),
                  ),

                  !_searchResult? IconButton(onPressed: () {

                    searchContacts();

                  }, icon: Icon(Icons.search)) : IconButton(onPressed: () {

                    showAllContacts();
                  }, icon: Icon(Icons.clear))
                ],
              ),
            ),
          ),

          SizedBox(height: 20,),

          Expanded(
              child: _loadingContacts? Column(
                children: [

                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),),
                      ),
                    ),
                  )

                ],
              ) : (!_rendererState? ListView(children: _contactsItems,) :
              Container(
                child: ListView(children: _contactsItems,),
              ))),

          SizedBox(height: 20,),
        ],
      ),
    );
  }


void showAllContacts () {
  setState(() {
    _contactsItems.clear();
  });
  for(Contact c in contacts) {
    setState(() {
      _contactsItems.add(ContactItem(contact: c,));
      _contactsItems.add(SizedBox(height: 10,));
    });
  }

  setState(() {
    _rendererState = !_rendererState;
    _searchResult = false;
    _searchQuery = null;
  });

}

bool _searchResult = false;
void searchContacts() {

  if(_searchQuery == null) {
    return;
  }

  if(contacts.length <= 0) {
    return;
  }

  setState(() {
    _contactsItems.clear();
  });
  for(Contact c in contacts.where((element) => element.displayName.toLowerCase().toString().contains(_searchQuery?.toLowerCase() as String))) {
    setState(() {
      _contactsItems.add(ContactItem(contact: c,));
      _contactsItems.add(SizedBox(height: 10,));
    });
  }

  setState(() {
    _rendererState = !_rendererState;
    _searchResult = true;
  });



}
}
