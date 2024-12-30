import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:transaction_tracker/boxes.dart';
import 'package:transaction_tracker/model/transaction.dart';
import 'package:transaction_tracker/theme.dart';
import 'package:transaction_tracker/widget/dropdown_widget.dart';
import 'package:transaction_tracker/widget/formfield_text.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final List<String> productOptions = [
    'Pulsa',
    'Token Listrik',
    'Kuota',
    'Dana',
    'Shopee',
    'e-wallet',
    'Mobile Legends',
    'Lain-lain',
  ];
  static String? valueProduct;

  final List<String> statusOptions = [
    'Belum Bayar',
    'Lunas',
  ];
  static String valueStatus = 'Belum Bayar';

  @override
  Widget build(BuildContext context) {
    DateTime parseDateTime(String text) {
      try {
        // Parse text sesuai dengan format yang mencakup tanggal, jam, dan menit
        final parsedDateTime = DateFormat("yyyy-MM-dd HH:mm").parse(text);

        // Ambil detik saat ini
        final currentSecond = DateTime.now().second;

        // Buat DateTime baru dengan detik saat ini
        return DateTime(
          parsedDateTime.year,
          parsedDateTime.month,
          parsedDateTime.day,
          parsedDateTime.hour,
          parsedDateTime.minute,
          currentSecond,
        );
      } catch (e) {
        print("Format tidak valid: $e");
        return DateTime.now();
      }
    }

    void writeData() {
      String nameValue = nameController.text;
      bool statusValue = (valueStatus == "Belum Bayar") ? false : true;
      String productValue = valueProduct ?? '(belum diset)';
      DateTime selectedDateTime = parseDateTime(timeController.text);

      setState(() {
        boxTransactions.add(
            // 2,
            Transaction(
                productType: productValue,
                totalPrice: double.parse(priceController.text),
                name: nameValue,
                isPaid: statusValue,
                time: selectedDateTime));

        Fluttertoast.showToast(
            msg: 'you\'ve set data as $nameValue\'s transaction');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Tambah Data',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                FormfieldText(
                    controller: nameController,
                    icon: null,
                    keyType: TextInputType.text,
                    labelField: 'Nama Pelanggan',
                    hintTxt: "(nama)"),
                SizedBox(
                  height: 20,
                ),
                DropdownWidget(
                    labeltxt: 'Jenis Produk',
                    hinttxt: "(Belum Dipilih)",
                    value: valueProduct,
                    dropdownItem: productOptions,
                    onChanged: (newVal) {
                      setState(() {
                        valueProduct = newVal!;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                FormfieldText(
                    controller: priceController,
                    icon: null,
                    keyType: TextInputType.number,
                    labelField: 'Harga',
                    hintTxt: "(nominal)"),
                const SizedBox(
                  height: 20,
                ),
                FormfieldText(
                  controller: timeController,
                  icon: IconButton(
                    onPressed: () {
                      selectDateTime(
                        context,
                        (selectedTime) => timeController.text = selectedTime,
                      );
                    },
                    icon: const Icon(
                      Icons.calendar_today,
                      color: primaryColor,
                    ),
                  ),
                  keyType: TextInputType.text,
                  labelField: "Waktu Transaksi",
                  hintTxt: "(otomatis / bisa diatur)",
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownWidget(
                    labeltxt: 'status',
                    hinttxt: "(Belum Dipilih)",
                    value: valueStatus,
                    dropdownItem: statusOptions,
                    onChanged: (newVal) {
                      setState(() {
                        valueStatus = newVal!;
                      });
                    }),
                const SizedBox(
                  height: 50,
                ),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: writeData,
                        child: Text(
                          'Simpan Data',
                          style: whiteTextStyle.copyWith(fontSize: 16),
                        )))
              ],
            ),
          ),
        ));
  }

  Future<void> selectDateTime(
      BuildContext context, Function(String) onDateTimeSelected) async {
    // Pilih tanggal terlebih dahulu
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Setelah tanggal dipilih, pilih waktu
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Gabungkan tanggal dan waktu
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format hasilnya sesuai kebutuhan
        final formattedDateTime =
            "${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')} "
            "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";

        onDateTimeSelected(formattedDateTime);
      }
    }
  }
}
