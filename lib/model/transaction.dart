import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String productType;
  @HiveField(1)
  final double totalPrice;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final bool isPaid;
  @HiveField(4)
  final DateTime time;

  Transaction({
    required this.productType,
    required this.totalPrice,
    required this.name,
    required this.isPaid,
    required this.time,
  });
}
