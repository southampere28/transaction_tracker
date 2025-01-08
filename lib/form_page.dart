import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transaction_tracker/boxes.dart';
import 'package:transaction_tracker/model/transaction.dart';
import 'package:transaction_tracker/provider/transaction_providers.dart';
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
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);

    void writeData() {
      String nameValue = nameController.text;
      bool statusValue = (valueStatus == "Belum Bayar") ? false : true;
      String productValue = valueProduct ?? '(belum diset)';

      transactionProvider.writeData(
          nameValue: nameValue,
          productValue: productValue,
          priceValue: double.parse(priceController.text),
          statusValue: statusValue,
          dateTimeText: timeController.text,
          context: context);
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
                const SizedBox(
                  height: 50,
                ),
                FormfieldText(
                    controller: nameController,
                    icon: null,
                    keyType: TextInputType.text,
                    labelField: 'Nama Pelanggan',
                    hintTxt: "(nama)"),
                const SizedBox(
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
      // ignore: use_build_context_synchronously
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        final formattedDateTime =
            "${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')} "
            "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";

        onDateTimeSelected(formattedDateTime);
      }
    }
  }
}
