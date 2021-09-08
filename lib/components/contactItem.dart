import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactItem extends StatefulWidget {

  Contact? contact;
  Function(Contact)? onPressed;

  ContactItem({this.contact, this.onPressed});

  @override
  _ContactItemState createState() => _ContactItemState(
    contact: contact, onPressed: onPressed
  );
}

class _ContactItemState extends State<ContactItem> {

  Contact? contact;
  Function(Contact)? onPressed;
  _ContactItemState({this.contact, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
            onPressed?.call(contact as Contact);
          },
          child: Row(
            children: [

              SizedBox(width: 5,),

              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.form,
                  shape: BoxShape.circle
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      width: double.infinity,
                      child: Text(contact?.displayName != null? (contact?.displayName as String) : ""),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      width: double.infinity,
                      child: Row(
                        children: contact?.phones.map((e) => Container(
                          height: 15,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(e != null? (e.number as String) : "",
                                  style: TextStyle(fontSize: 12, color: AppColors.mediumGray),),
                                SizedBox(width: 5,)
                              ],
                            ),
                          )
                        )).toList() as List<Widget>,
                      )
                    ),

                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
