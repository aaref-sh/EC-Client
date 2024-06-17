import 'package:tt/models/account.dart';
import 'package:tt/models/account_type.dart';

bool showTableHeaders = true;
String lang = 'ar';

// String host = "http://10.0.2.2:5213/api/";
String host = "http://192.168.1.109:5213/api/";

List<Account> baseAccounts = <Account>[];
List<AccountType> accountTypes = [];
String token = '';
String name = '';
