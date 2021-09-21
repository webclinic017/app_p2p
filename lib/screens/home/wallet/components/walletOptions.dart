import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/wallet/components/optionButton.dart';
import 'package:flutter/material.dart';

class WalletOptions extends StatefulWidget {

  Function()? onClose;
  Function()? onSendMoneyPressed;
  Function()? onReceiveMoneyPressed;
  Function()? onAddFundsPressed;


  WalletOptions({this.onClose, this.onSendMoneyPressed, this.onReceiveMoneyPressed, this.onAddFundsPressed});

  @override
  _WalletOptionsState createState() => _WalletOptionsState(onClose: onClose, onSendMoneyPressed: onSendMoneyPressed,
  onReceiveMoneyPressed: onReceiveMoneyPressed, onAddFundsPressed: onAddFundsPressed);
}

class _WalletOptionsState extends State<WalletOptions> {

  Function()? onClose;
  Function()? onSendMoneyPressed;
  Function()? onReceiveMoneyPressed;
  Function()? onAddFundsPressed;

  _WalletOptionsState({this.onClose, this.onSendMoneyPressed, this.onReceiveMoneyPressed, this.onAddFundsPressed});



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5)
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          onTap: onClose,
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                ),
                child: Column(
                  children: [

                    OptionButton(icon: Icons.money, text: loc(context, "send_money"),
                    onPressed: () {
                      onClose?.call();
                      onSendMoneyPressed?.call();
                    },),

                    Divider(color: Colors.black.withOpacity(0.3), height: 1,indent: 20,
                      endIndent: 20,),

                    OptionButton(icon: Icons.attach_money, text: loc(context,  "receive_money"),
                    onPressed: () {
                      onClose?.call();
                      onReceiveMoneyPressed?.call();
                    },),

                    Divider(color: Colors.black.withOpacity(0.3), height: 1, indent: 20,
                    endIndent: 20,),

                    OptionButton(icon: Icons.add, text: loc(context,  "add_funds"),
                      onPressed: () {
                        onClose?.call();
                        onAddFundsPressed?.call();
                      },),

                    Divider(color: Colors.black.withOpacity(0.3), height: 1,indent: 20,
                      endIndent: 20,),



                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
