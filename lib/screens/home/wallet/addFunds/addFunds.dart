import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/wallet/addFunds/addFundsBalance.dart';
import 'package:app_p2p/screens/home/wallet/addFunds/addFundsCheckout.dart';
import 'package:app_p2p/screens/home/wallet/addFunds/addFundsMethod.dart';
import 'package:app_p2p/screens/home/wallet/addFunds/components/addFundsCaller.dart';
import 'package:app_p2p/screens/home/wallet/components/completionIndicator.dart';
import 'package:app_p2p/screens/home/wallet/components/completionIndicatorController.dart';
import 'package:app_p2p/screens/home/wallet/components/completionIndicatorViewPage.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class AddFunds extends StatefulWidget {
  const AddFunds({Key? key}) : super(key: key);

  @override
  _AddFundsState createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {

  CompletionIndicatorController _indicatorController = CompletionIndicatorController();

  String? _selectedMethod;
  BalanceData? _selectedBalance;
  ExchangeData? _selectedExchange;
  AddFundsCaller? caller = AddFundsCaller();

  bool get canShowLast {


    return _selectedBalance != null && _selectedExchange != null && _selectedMethod != null;
  }



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
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(loc(context, "method"),
                        textAlign: TextAlign.left,),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 100,
                        child: Text(loc(context, "balance"),
                          textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 100,
                        child: Text(loc(context, "checkout"),
                          textAlign: TextAlign.right,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: CompletionIndicator(pagesCount: 3, controller: _indicatorController,
                  indicatorColor: AppColors.secondary,),
                ),

                SizedBox(height: 20,),

                Expanded(
                  child: CompletionIndicatorViewPage(
                    controller: _indicatorController,
                    children: [
                      AddFundsMethod( onMethodSelected: (method) {

                        setState(() {
                          _selectedMethod = method;
                        });
                        _indicatorController.call(1);

                      }, ),
                      AddFundsBalance(onSelected: (data, exchange) {

                        setState(() {
                          _selectedBalance = data;
                          _selectedExchange = exchange;
                        });
                        print("CanShowLast: ${canShowLast}");

                        caller?.update(_selectedMethod as String, _selectedBalance as BalanceData, _selectedExchange as ExchangeData);
                        print("CanShowLast: ${canShowLast}");

                        _indicatorController.call(2);
                      }, onBack: () {
                        _indicatorController.call(0);
                      },),
                      AddFundsCheckout(caller: caller,)
                    ],
                  ),
                )



              ],
            ),
          )


        ],
      ),
    );
  }
}
