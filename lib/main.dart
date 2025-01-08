import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transaction_tracker/form_page.dart';
import 'package:transaction_tracker/home_page.dart';
import 'package:transaction_tracker/model/transaction.dart';
import 'package:transaction_tracker/boxes.dart';
import 'package:transaction_tracker/provider/transaction_providers.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => TransactionProvider(boxTransactions)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const HomePage(),
          '/form-page': (context) => const FormPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
