import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:transaction_tracker/home_page.dart';
import 'package:transaction_tracker/model/transaction.dart';

import 'package:transaction_tracker/boxes.dart';

void main() async {
  // initialize hive flutter
  await Hive.initFlutter();

  // registering adapter
  Hive.registerAdapter(TransactionAdapter());
  
  // openbox
  boxTransactions = await Hive.openBox<Transaction>('transactionBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
