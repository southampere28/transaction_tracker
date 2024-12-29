import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:transaction_tracker/boxes.dart';
import 'package:transaction_tracker/model/transaction.dart';
import 'package:transaction_tracker/widget/card_transaksi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalAll = 0;
  double totalPriceUnpaid = 0;
  double totalPricePaid = 0;

  void calculateTotal() {
    double total = 0;
    double unpaidTotal = 0;
    double paidTotal = 0;

    for (int i = 0; i < boxTransactions.length; i++) {
      Transaction? transaction = boxTransactions.getAt(i);
      if (transaction != null) {
        total += transaction.totalPrice;
        if (!transaction.isPaid) {
          unpaidTotal += transaction.totalPrice;
        } else {
          paidTotal += transaction.totalPrice;
        }
      }
    }

    setState(() {
      totalAll = total;
      totalPriceUnpaid = unpaidTotal;
      totalPricePaid = paidTotal;
    });
  }

  void writeData() {
    String nameValue = 'zidan';

    setState(() {
      boxTransactions.add(
          // 2,
          Transaction(
              productType: "Dana",
              totalPrice: 23000,
              name: nameValue,
              isPaid: false,
              time: DateTime.now()));

      Fluttertoast.showToast(
          msg: 'you\'ve set data as $nameValue\'s transaction');
      calculateTotal();
    });
  }

  Transaction getData() {
    Transaction logResult = boxTransactions.get(1);
    return logResult;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          right: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatCurrency(totalAll),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),
                // paid category
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          right: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sukses',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatCurrency(totalPricePaid),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),
                // unpaid category
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          right: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Belum Dibayar',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          formatCurrency(totalPriceUnpaid),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: boxTransactions.length,
              itemBuilder: (context, index) {
                List transactions =
                    boxTransactions.values.toList().reversed.toList();
                Transaction transaction = transactions[index];
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(transaction.time);
                // Variabel untuk memeriksa perubahan tanggal
                bool isNewDate = (index == 0 ||
                    formattedDate !=
                        DateFormat('yyyy-MM-dd')
                            .format(transactions[index - 1].time));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNewDate) // Tambahkan teks tanggal jika tanggal baru
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Text(
                          DateFormat('EEEE, dd MMMM yyyy').format(transaction
                              .time), // Format tanggal lebih user-friendly
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    CardTransaksi(
                      id: 'id',
                      title: '${transaction.name} (${transaction.productType})',
                      dateTime:
                          DateFormat('dd/MM/yyyy').format(transaction.time),
                      time: DateFormat('HH:mm:ss').format(transaction.time),
                      via: formatCurrency(transaction.totalPrice),
                      status: transaction.isPaid,
                      onDelete: () {
                        setState(() {
                          boxTransactions
                              .deleteAt(transactions.length - 1 - index);
                          calculateTotal();
                        });
                      },
                      onUpdate: () {
                        transaction = Transaction(
                          productType: transaction.productType,
                          totalPrice: transaction.totalPrice,
                          name: transaction.name,
                          isPaid: true, // Set nilai isPaid menjadi true
                          time: transaction.time,
                        );

                        setState(() {
                          boxTransactions.putAt(
                              transactions.length - 1 - index, transaction);
                          calculateTotal();
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: writeData,
        child: Icon(Icons.add),
      ),
    );
  }

  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID', // Menggunakan lokal Indonesia
      symbol: 'Rp ', // Menambahkan simbol Rupiah
      decimalDigits: 0, // Tidak menampilkan desimal
    );
    return formatCurrency.format(amount);
  }
}
