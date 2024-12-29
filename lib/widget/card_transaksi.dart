import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transaction_tracker/theme.dart';

class CardTransaksi extends StatelessWidget {
  const CardTransaksi({
    super.key,
    required this.id,
    required this.title,
    required this.dateTime,
    required this.time,
    required this.via,
    required this.status,
    required this.onDelete, required this.onUpdate,
  });

  final String id;
  final String title;
  final String dateTime;
  final String time;
  final String via;
  final bool status;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: liteblueColor,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 52),
                child: Text(
                  title,
                  style:
                      blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 24,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(dateTime),
                  SizedBox(
                    width: 8,
                  ),
                  Text(time),
                  Spacer(),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(via),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 28,
                    width: 80,
                    decoration: BoxDecoration(
                      color: status ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        status ? 'Sukses' : 'Pending',
                        style: whiteTextStyle.copyWith(
                            fontSize: 10, fontWeight: bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete,
                  size: 28,
                )),
            SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: onUpdate,
              child: Icon(
                Icons.edit,
                size: 28,
              ),
            ),
          ])
        ],
      ),
    );
  }
}
