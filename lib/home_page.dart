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
              time: DateTime.now().subtract(Duration(days: 1))));

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
    Future<void> confirmDelete(
        BuildContext context, int indexToDelete, String name) async {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Apakah kamu yakin ingin menghapus data dengan nama pelanggan \'$name\' ini?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    if (indexToDelete != -1) {
                      boxTransactions.deleteAt(indexToDelete);
                      calculateTotal();
                    }
                    Fluttertoast.showToast(msg: 'Data Berhasil Dihapus');
                    Navigator.pop(context);
                  });
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    Future<void> confirmUpdate(BuildContext context, String title,
        int indexToUpdate, bool paidStatus) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // 80% of screen width
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensures dialog fits its content
                children: [
                  Text(
                    "Konfirmasi Perubahan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    paidStatus
                        ? "Apakah Anda yakin ingin mengubah status pembayaran untuk '$title' menjadi belum dibayar?"
                        : "Apakah Anda yakin ingin mengubah status pembayaran untuk '$title' menjadi Lunas?",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Batal"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (indexToUpdate != -1) {
                            Transaction transactionToUpdate =
                                boxTransactions.getAt(indexToUpdate);

                            Transaction transaction = Transaction(
                              productType: transactionToUpdate.productType,
                              totalPrice: transactionToUpdate.totalPrice,
                              name: transactionToUpdate.name,
                              isPaid: paidStatus
                                  ? false
                                  : true, // Set nilai isPaid menjadi true
                              time: transactionToUpdate.time,
                            );

                            setState(() {
                              boxTransactions.putAt(indexToUpdate, transaction);
                              calculateTotal();
                            });
                          }
                          Navigator.of(context).pop(); // Close dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              paidStatus ? Colors.red : Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Ya, Lanjutkan"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

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
                List transactions = boxTransactions.values.toList().toList()
                  ..sort((a, b) => b.time.compareTo(a.time));
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
                        final indexToDelete =
                            boxTransactions.values.toList().indexWhere(
                                  (t) => t.time == transaction.time,
                                );

                        confirmDelete(context, indexToDelete, transaction.name);
                      },
                      onUpdate: () {
                        final indexToUpdate =
                            boxTransactions.values.toList().indexWhere(
                                  (t) => t.time == transaction.time,
                                );
                        confirmUpdate(context, transaction.name, indexToUpdate,
                            transaction.isPaid);
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
        onPressed: () {
          Navigator.pushNamed(context, '/form-page');
        },
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
