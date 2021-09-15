import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class BalanceItemPlaceHolder extends StatefulWidget {


  @override
  _BalanceItemPlaceHolderState createState() => _BalanceItemPlaceHolderState();
}

class _BalanceItemPlaceHolderState extends State<BalanceItemPlaceHolder> {



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: Row(
        children: [
          SizedBox(width: 10,),

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle
            ),
          ),

          SizedBox(width: 10,),

          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: double.infinity,
                    height: 15,

                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [

                              Container(
                                width: 80,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5)
                                ),
                              )

                            ],
                          )
                        ),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Container(
                                width: 120,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)
                                ),
                              )

                            ],
                          ),
                        )

                      ],
                    ),
                  ),

                  SizedBox(height: 2,),

                  Container(
                    width: double.infinity,
                    height: 15,

                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                              children: [

                                Container(
                                  width: 50,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5)
                                  ),
                                )

                              ],
                            )
                        ),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Container(
                                width: 80,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)
                                ),
                              )

                            ],
                          ),
                        )

                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  Divider(color: Colors.white.withOpacity(0.5), height: 10,),

                  Container(
                    width: double.infinity,
                    height: 6,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5)
                                ),
                              )

                            ],
                          ),
                        ),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)
                                ),
                              )

                            ],
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}
