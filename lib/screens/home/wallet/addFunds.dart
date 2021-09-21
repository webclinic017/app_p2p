import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/wallet/components/completionIndicator.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class AddFunds extends StatefulWidget {
  const AddFunds({Key? key}) : super(key: key);

  @override
  _AddFundsState createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loc(context, "add_funds"),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
        onPressed: () {
          Navigator.pop(context);
        },),
      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [

                SizedBox(height: 30,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: CompletionIndicator(pagesCount: 3),
                )



              ],
            ),
          )


        ],
      ),
    );
  }
}
