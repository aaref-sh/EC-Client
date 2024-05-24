import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/account.dart';
import 'package:tt/routes/home.dart';

void main() {
  Dio dio = Dio();
  dio.get("${host}Account/GetBaseAccounts").then((value) {
    baseAccounts = List<Account>.from(value.data['data'].entries
        .map((x) => Account(id: x.value, name: x.key))
        .toList());
  }).onError((error, stackTrace) => null);

  runApp(const MyApp());
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
        child: HomePage(),
      ),
    );
  }
}
