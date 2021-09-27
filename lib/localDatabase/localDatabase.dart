import 'package:app_p2p/database/currencyData.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';



class LocalDatabase {
  
  static Database? _database;

  static String _databaseName = "Exchanges.db";

  static String get fiatsTableName {
    return "fiats";
  }

  static String get cryptosTableName {
    return "cryptos";
  }

  static String get assetsTableName {
    return "assets";
  }


  
  
  static Future<Database> get database async {
    if(_database != null) {
      return _database as Database;
    }else {

      _database =  await initDb();

      return _database as Database;

    }
    
  } 
  
  
  static Future<Database> initDb() async {


    var documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async{

      await db.execute("CREATE TABLE $fiatsTableName ("
          "id INTEGER PRIMARY KEY,"
          "code TEXT,"
          "name TEXT"
          ")");

      await db.execute("CREATE TABLE $cryptosTableName ("
          "id INTEGER PRIMARY KEY,"
          "code TEXT,"
          "name TEXT"
          ")");

      await db.execute("CREATE TABLE $assetsTableName ("
          "id INTEGER PRIMARY KEY,"
          "code TEXT,"
          "name TEXT"
          ")");






    });
    
  }



  static Future<int> insertFiat(CurrencyData currency) async{
    var db = await database;


   await db.delete(fiatsTableName, where: "code = ?", whereArgs: [currency.code]);

   return await db.insert(fiatsTableName, currency.toMap());

  }

  static Future<void> insertAll(List<CurrencyData> currencyList, int type) async{
    var db = await database;

    String values = "";

    for(CurrencyData currency in currencyList) {
      values += "${currency.toDatabaseString()},";
    }



    String finalValue = values.substring(0, values.length - 1);



    String tableName = "$fiatsTableName";

    if(type == 0) {
      tableName = "$fiatsTableName";
    }else if(type == 1) {
      tableName = "$cryptosTableName";
    }else if(type == 2) {
      tableName = "$assetsTableName";
    }



    await db.delete(tableName);
    await db.execute("INSERT INTO $tableName (name, code) VALUES $finalValue");



  }


  static Future<List<CurrencyData>> loadCurrencies(int type, {limit: int}) async {
    var db = await database;

    String tableName = "$fiatsTableName";

    if(type == 0) {
      tableName = "$fiatsTableName";
    }else if(type == 1) {
      tableName = "$cryptosTableName";
    }else if(type == 2) {
      tableName = "$assetsTableName";
    }




    List<Map<String, Object?>> maps = await db.query(tableName, limit: limit);

    return List.generate(maps.length, (index) => CurrencyData(
      name: maps[index]["name"] as String,
      code: maps[index]["code"] as String
    ));

  }


  static Future<List<CurrencyData>> loadCurrenciesAfterIndex(int type, {limit: int, from: int}) async {
    var db = await database;

    String tableName = "$fiatsTableName";

    if(type == 0) {
      tableName = "$fiatsTableName";
    }else if(type == 1) {
      tableName = "$cryptosTableName";
    }else if(type == 2) {
      tableName = "$assetsTableName";
    }




    List<Map<String, Object?>> maps = await db.query(tableName, limit: limit, offset: from);

    return List.generate(maps.length, (index) => CurrencyData(
        name: maps[index]["name"] as String,
        code: maps[index]["code"] as String
    ));

  }
  
  
  
  
}

  

