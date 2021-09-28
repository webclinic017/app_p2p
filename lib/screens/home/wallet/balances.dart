import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/currencyData.dart';
import 'package:app_p2p/localDatabase/localDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/wallet/displayBalance.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/currenciesManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Balances extends StatefulWidget {

  int? type;
  Balances({this.type});

  @override
  _BalancesState createState() => _BalancesState(type: type);
}

class _BalancesState extends State<Balances> {

  int? type;
  _BalancesState({this.type});

  bool _renderState = false;


  String get balanceType {
    if(type == 0) {
      return loc(context, "more_fiats");
    }else if(type == 1) {
      return loc(context, "more_crypto");
    }else if(type == 2) {
      return loc(context, "more_assets");
    }else if(type == 3) {
      return loc(context, "shares");
    }

    return loc(context, "fiat");
  }


  List<Widget> _balances = [];

  @override
  void initState() {

    if(type == 0) {
      loadFiatCurrencies();
    }else if(type == 1) {
      loadCryptoCurrencies();
    }else if(type == 2) {
      loadAssetsCurrencies();
    }else if(type == 3) {
      loadShares();
    }
    super.initState();
  }



  bool _loadingBalances = false;


  void loadFiatCurrencies() async{

    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });
    LocalDatabase.loadCurrencies(0, limit: null).then((currencies) {

      if(currencies.length > 0) {

        for(CurrencyData fiat in currencies) {




          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: fiat.name, currencyCode: fiat.code,
              isFiat: true,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));
        }
        setState(() {
          _loadingBalances = false;
        });

        print("Fiat currencies loaded locally!");

      }else {
        loadFiatRemotely();
      }

    });



  }

  void loadFiatRemotely () async{
    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });


    List<CurrencyData> _currencyList = [];

    for(Map<String, dynamic> fiatMap in await CurrenciesManager.loadFiatCurrencies()) {

      CurrencyData fiat = CurrencyData.fromMap(fiatMap);

      _currencyList.add(fiat);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: fiat.name, currencyCode: fiat.code,
          isFiat: true,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));


        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));


    }

    setState(() {
      _loadingBalances = false;
    });



    LocalDatabase.insertAll(_currencyList, 0);
  }




  int _limit = 50;
  void loadCryptoCurrencies () async{

    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    LocalDatabase.loadCurrencies(1, limit: null).then((currencies) {

      if(currencies.length > 0) {

        for(CurrencyData crypto in currencies) {
          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: crypto.name, currencyCode: crypto.code,
              isFiat: false,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));


        }

        setState(() {
          _loadingBalances = false;
        });

        print("Crypto loaded locally!");
      }else {
        loadCryptoRemotely();
      }



    });




  }




  void loadCryptoRemotely() async{

    List<CurrencyData> _currencyList = [];
    int counter = 0;
    for(Map<String, dynamic> cryptoMap in await CurrenciesManager.loadCryptoCurrencies()) {

      CurrencyData crypto = CurrencyData.fromMap(cryptoMap);

      _currencyList.add(crypto);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: crypto.name, currencyCode: crypto.code,
          isFiat: false,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));
        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));

      counter ++;

    }

    print("Crypto loaded remotely");
    setState(() {
      _loadingBalances = false;
    });

    LocalDatabase.insertAll(_currencyList, 1);
  }








  void loadAssetsCurrencies() async{

    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    LocalDatabase.loadCurrencies(2, limit: null).then((currencies) {

      if(currencies.length > 0) {

        for(CurrencyData commodities in currencies) {
          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: commodities.name, currencyCode: commodities.code,
              isFiat: false,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));
        }

        setState(() {
          _loadingBalances = false;
        });

        print("Assets loaded locally!");


      }else {
        loadAssetsRemotely();
      }

    });

  }

  void loadAssetsRemotely() async{

    setState(() {
      _loadingBalances = true;

    });


    List<CurrencyData> _currencyList = [];

    for(Map<String, dynamic> commoditiesMap in await CurrenciesManager.loadAssets()) {

      CurrencyData commodities = CurrencyData.fromMap(commoditiesMap);

      _currencyList.add(commodities);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: commodities.name, currencyCode: commodities.code,
          isFiat: false,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));
        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));
    }

    setState(() {
      _loadingBalances = false;
    });

    LocalDatabase.insertAll(_currencyList, 2);
    print("Assets loaded remotely");

  }


  int _sharesIndex = 0;
  void loadShares() {
    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    LocalDatabase.loadCurrencies(3, limit: 50).then((currencies) {

      _sharesIndex = 0;
      if(currencies.length > 0) {

        for(CurrencyData shares in currencies) {
          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: shares.name, currencyCode: shares.code,
              isFiat: false,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));

          _sharesIndex ++;
        }
        if(currencies.length >= 50) {
          setState(() {
            _balances.add(LoadMore(onLoad: () {

              loadMoreShares();
            },));
          });
        }

        setState(() {
          _loadingBalances = false;
          _renderState = !_renderState;
        });

        print("Shares loaded locally!");


      }else {
        loadSharesRemotely();
      }

    });

  }

  void loadMoreShares() {

    LocalDatabase.loadCurrenciesAfterIndex(3, limit: 50, from: _sharesIndex).then((currencies) {


      if(currencies.length > 0) {

        for(CurrencyData shares in currencies) {
          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: shares.name, currencyCode: shares.code,
              isFiat: false,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));

          _sharesIndex ++;
        }
        if(currencies.length >= 50) {
          setState(() {
            _balances.add(LoadMore(onLoad: () {

              loadMoreShares();
            },));
          });
        }

        setState(() {
          _renderState = !_renderState;
        });


        print("Shares loaded locally!");


      }else {
        loadSharesRemotely();
      }

    });

  }


  void loadSharesRemotely() async{
    List<CurrencyData> _sharesList = [];

    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    int shareCount = 0;
    _sharesIndex = 0;
    for(Map<String, dynamic> shares in await CurrenciesManager.loadShares()) {

      CurrencyData commodities = CurrencyData.fromMap(shares);

      _sharesList.add(commodities);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: commodities.name, currencyCode: commodities.code,
          isFiat: false,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));
        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));
      shareCount ++;
      _sharesIndex ++;
    }



    if(shareCount >= 50) {
      setState(() {
        _balances.add(LoadMore(onLoad: () {

          loadMoreSharesRemotely();
        },));

      });
    }

    setState(() {
      _loadingBalances = false;
      _renderState = !_renderState;
    });

    LocalDatabase.insertAll(_sharesList, 3);
    print("Shares loaded remotely");
  }


  void loadMoreSharesRemotely () async{
    List<CurrencyData> _sharesList = [];



    int shareCount = 0;
    for(Map<String, dynamic> shares in await CurrenciesManager.loadSharesWithOffset(_sharesIndex)) {

      CurrencyData commodities = CurrencyData.fromMap(shares);

      _sharesList.add(commodities);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: commodities.name, currencyCode: commodities.code,
          isFiat: false,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));
        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));
      shareCount ++;
      _sharesIndex ++;
    }

    if(shareCount >= 50) {
      setState(() {
        _balances.add(LoadMore(onLoad: () {

          loadMoreSharesRemotely();
        },));
      });
    }

    setState(() {
      _renderState = !_renderState;
    });

    LocalDatabase.insertAll(_sharesList, 3);
    print("Shares loaded remotely");
  }

  String get searchText {

    if(type == 0) {
      return loc(context, "search_fiat");
    }else if(type == 1) {
      return loc(context, "search_crypto");
    }else if(type == 2) {
      return loc(context, "search_asset");
    }else {
      return loc(context, "search_share");
    }
  }

  String? _searchQuery;

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(balanceType, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
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
            child: Column(
              children: [

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  height: 45,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45),
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
                                hintText: searchText,
                                hintStyle: TextStyle(color: AppColors.mediumGray)

                            ),
                            controller: _searchController,
                            onChanged: (value) {
                              if(value.isEmpty) {

                                clearSearch();
                              }else {
                                setState(() {
                                  _searchQuery = value;
                                });
                              }

                            },
                            onFieldSubmitted: (value) {

                              setState(() {
                                _searchQuery = value;
                              });

                              performSearch();

                            },
                          ),
                        ),

                        !_searchResult? IconButton(onPressed: () {

                          performSearch();

                        }, icon: Icon(Icons.search)) : IconButton(onPressed: () {

                          clearSearch();

                        }, icon: Icon(Icons.clear))
                      ],
                    )
                  ),
                ),


                Expanded(
                  child: _loadingBalances? Column(
                    children: [
                      SizedBox(height: 20,),

                      Container(
                        width: double.infinity,
                        height: 40,
                        child: Align(
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),),
                          ),
                        ),
                      )

                    ],
                  ) : Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: !_renderState? ListView(
                                children: _balances,
                              ) : Container(
                                child: ListView(
                                  children: _balances,
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }



  void performSearch() {
    if(type == 0) {
      searchFiat();

    }else if(type == 1) {
      searchCrypto();
    }else if(type == 2) {
      searchAssets();
    }else if(type == 3) {
      searchShares();
    }
  }

  void clearSearch() {
    setState(() {
      _searchResult = false;
      _searchQuery = null;
      _searchController.clear();
    });
    if(type == 0) {
      loadFiatCurrencies();
    }else if(type == 1) {
      loadCryptoCurrencies();
    }else if(type == 2) {
      loadAssetsCurrencies();
    }else if(type == 3) {
      loadSharesRemotely();
    }
  }

  bool _searchResult = false;


  void searchFiat () {

    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    LocalDatabase.searchCurrencies(0, _searchQuery as String).then((currencies) {
      for(CurrencyData fiat in currencies) {
        BalanceData balanceData = BalanceData(amount: 0.0,
            currencyName: fiat.name, currencyCode: fiat.code,
            isFiat: false,
            created: DateTime.now());

        _balances.add(BalanceItem(data: balanceData,
          onPressed: (data, exchange) {

            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                },)));
          }, onlyShow: true,));
        _balances.add(SizedBox(height: 20,));


      }


      setState(() {
        _loadingBalances = false;
        _renderState = !_renderState;
        _searchResult = true;
      });

      print("Fiats searched!");


    });


  }

  void searchCrypto() {
    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    LocalDatabase.searchCurrencies(1, _searchQuery as String).then((currencies) {
      for(CurrencyData crypto in currencies) {
        BalanceData balanceData = BalanceData(amount: 0.0,
            currencyName: crypto.name, currencyCode: crypto.code,
            isFiat: false,
            created: DateTime.now());

        _balances.add(BalanceItem(data: balanceData,
          onPressed: (data, exchange) {

            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                },)));
          }, onlyShow: true,));
        _balances.add(SizedBox(height: 20,));


      }


      setState(() {
        _loadingBalances = false;
        _renderState = !_renderState;
        _searchResult = true;
      });

      print("Crypto searched!");


    });
  }

  void searchAssets () {
    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    LocalDatabase.searchCurrencies(2, _searchQuery as String).then((currencies) {
      for(CurrencyData assets in currencies) {
        BalanceData balanceData = BalanceData(amount: 0.0,
            currencyName: assets.name, currencyCode: assets.code,
            isFiat: false,
            created: DateTime.now());

        _balances.add(BalanceItem(data: balanceData,
          onPressed: (data, exchange) {

            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                },)));
          }, onlyShow: true,));
        _balances.add(SizedBox(height: 20,));


      }


      setState(() {
        _loadingBalances = false;
        _renderState = !_renderState;
        _searchResult = true;
      });

      print("Assets searched!");


    });
  }

  void searchShares () {
    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });

    LocalDatabase.searchCurrencies(3, _searchQuery as String).then((currencies) {
      for(CurrencyData shares in currencies) {
        BalanceData balanceData = BalanceData(amount: 0.0,
            currencyName: shares.name, currencyCode: shares.code,
            isFiat: false,
            created: DateTime.now());

        _balances.add(BalanceItem(data: balanceData,
          onPressed: (data, exchange) {

            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                },)));
          }, onlyShow: true,));
        _balances.add(SizedBox(height: 20,));


      }


      setState(() {
        _loadingBalances = false;
        _renderState = !_renderState;
        _searchResult = true;
      });

      print("Shares searched!");


    });
  }
}
