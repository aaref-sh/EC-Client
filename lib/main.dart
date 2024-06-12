import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/helpers/neteork_helper.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/account.dart';
import 'package:tt/models/account_type.dart';
import 'package:tt/models/voucher.dart';
import 'package:tt/routes/home.dart';
import 'package:tt/routes/login.dart';

void main() {
  loadEsentials();

  runApp(const MyApp());
}

Future<void> loadEsentials() async {
  try {
    var response = await Future.wait([
      fetchFromServer(
          controller: "Account",
          fromJson: Account.fromJson,
          headers: ListAccountRequest(level: 2)),
      fetchFromServer(
          controller: "General",
          fromJson: AccountType.fromJson,
          action: "GetAccountCodes")
    ]);

    baseAccounts = response[0] as List<Account>;

    accountTypes = response[1] as List<AccountType>;
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: Login(),
      ),
    );
  }
}
