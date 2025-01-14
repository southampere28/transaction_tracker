import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:transaction_tracker/model/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final Box<dynamic> _transactionBox;

  // Variabel for storing total information
  double _totalAll = 0;
  double _totalPriceUnpaid = 0;
  double _totalPricePaid = 0;
  int _transactionCount = 0;
  int _transactionPaidCount = 0;
  int _transactionUnpaidCount = 0;

  // Getter for get total information
  double get totalAll => _totalAll;
  double get totalPriceUnpaid => _totalPriceUnpaid;
  double get totalPricePaid => _totalPricePaid;
  int get transactionCount => _transactionCount;
  int get transactionPaidCount => _transactionPaidCount;
  int get transactionUnpaidCount => _transactionUnpaidCount;

  TransactionProvider(this._transactionBox) {
    calculateTotal();
  }

  // Ambil data langsung dari Hive
  List<dynamic> get transactions =>
      _transactionBox.values.toList()..sort((a, b) => b.time.compareTo(a.time));

  // function gettransaction (index) by time
  int getTransactionIndexByTime(DateTime time) {
    for (int i = 0; i < _transactionBox.length; i++) {
      final transaction = _transactionBox.getAt(i);
      if (transaction != null && transaction.time == time) {
        return i;
      }
    }
    return -1; // Return -1 jika tidak ditemukan
  }

  // function gettransaction (data) by index
  Transaction getTransactionAtIndex(int index) {
    if (index >= 0 && index < _transactionBox.length) {
      return _transactionBox.getAt(index);
    } else {
      throw (
        index,
        _transactionBox.values.toList(),
        'Index out of bounds in transaction list'
      );
    } // Return null jika indeks tidak valid
  }

  void deleteTransaction(int index) {
    _transactionBox.deleteAt(index);
    calculateTotal(); // Beritahu perubahan
  }

  void updateTransaction(int index, Transaction updatedTransaction) {
    _transactionBox.putAt(index, updatedTransaction);
    calculateTotal(); // Beritahu perubahan
  }

  void calculateTotal() {
    double total = 0;
    double unpaidTotal = 0;
    double paidTotal = 0;
    int transactionTotal = 0;
    int transactionPaidTotal = 0;
    int transactionUnpaidTotal = 0;

    for (var transaction in _transactionBox.values) {
      total += transaction.totalPrice;
      transactionTotal++;
      if (!transaction.isPaid) {
        unpaidTotal += transaction.totalPrice;
        transactionUnpaidTotal++;
      } else {
        paidTotal += transaction.totalPrice;
        transactionPaidTotal++;
      }
    }

    // Update variabel dengan hasil perhitungan
    _totalAll = total;
    _totalPriceUnpaid = unpaidTotal;
    _totalPricePaid = paidTotal;
    _transactionCount = transactionTotal;
    _transactionPaidCount = transactionPaidTotal;
    _transactionUnpaidCount = transactionUnpaidTotal;

    // Notifikasi ke widget
    notifyListeners();
  }

  void writeData({
    required String nameValue,
    required String productValue,
    required double priceValue,
    required bool statusValue,
    required String dateTimeText,
    required BuildContext context,
  }) {
    // Parse the date using the helper method
    DateTime selectedDateTime = parseDateTime(dateTimeText);

    // Create and add the transaction
    Transaction newTransaction = Transaction(
      productType: productValue,
      totalPrice: priceValue,
      name: nameValue,
      isPaid: statusValue,
      time: selectedDateTime,
    );

    _transactionBox.add(newTransaction);

    Fluttertoast.showToast(
        msg: 'You\'ve set data as $nameValue\'s transaction');
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    calculateTotal();
  }

  DateTime parseDateTime(String text) {
    try {
      final parsedDateTime = DateFormat("yyyy-MM-dd HH:mm").parse(text);
      final currentSecond = DateTime.now().second;

      return DateTime(
        parsedDateTime.year,
        parsedDateTime.month,
        parsedDateTime.day,
        parsedDateTime.hour,
        parsedDateTime.minute,
        currentSecond,
      );
    } catch (e) {
      print("Invalid format: $e");
      return DateTime.now();
    }
  }
}
