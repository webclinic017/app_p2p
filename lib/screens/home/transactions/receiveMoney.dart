import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/components/balancePicker.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveMoney extends StatefulWidget {
  const ReceiveMoney({Key? key}) : super(key: key);

  @override
  _ReceiveMoneyState createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {

  BalanceData? _selectedBalance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "receive_money"),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),

      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child:  Column(
                children: [

                  SizedBox(height: 40,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "select_balance"),
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "select_the_balance_where_you_want_to_receive_the_funds"),
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.mediumGray),),
                  ),

                  SizedBox(height: 5,),

                  _selectedBalance == null?Container(
                      width: double.infinity,
                      height: 60,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      decoration: BoxDecoration(
                          color: AppColors.lightForm,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                      ),
                      child: Material(
                        color: Colors.white.withOpacity(0.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => BalancePicker(
                              onBalanceSelected: (data) {

                                setState(() {
                                  _selectedBalance = data;
                                  generateQrCode();
                                });

                              },
                            )));
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 20,),

                              Text(loc(context, "choose_balance"),
                                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.mediumGray),)

                            ],
                          ),
                        ),
                      )

                  ) : Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: BalanceItem(data: _selectedBalance,
                      onPressed: (data, exchange) {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => BalancePicker(
                          onBalanceSelected: (data) {

                            setState(() {
                              _selectedBalance = data;
                              generateQrCode();
                            });

                          },
                        )));

                      },),
                  ),



                  SizedBox(height: 50),

                  _qrImage != null? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "generated_qr"),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                  ) : Container(),

                  _qrImage != null? SizedBox(height: 10) : Container(),

                  _qrImage != null? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "show_this_qr_to_any_user_you_want_to_send_you_funds"),
                      style: TextStyle(fontWeight: FontWeight.w600,
                      color: AppColors.mediumGray),),
                  ) : Container(),

                  _qrImage != null? SizedBox(height: 10) : Container(),

                  _qrImage != null? Container(
                      width: double.infinity,
                      height: 200,
                      child: Align(
                        alignment: Alignment.center,
                        child: _qrImage,
                      )
                  ) : Container(),

                  SizedBox(height: 50,)




                ],
              ),
            )
          )
        ],
      ),
    );
  }

  QrImage? _qrImage;


  void generateQrCode() {

    String code = "${userID}-${_selectedBalance?.id}";

    setState(() {
      _qrImage = QrImage(data: code,
      version: QrVersions.auto,
      size: 200,);
    });


  }
}
