import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(
          child: Column(
            children: [
              Text('주문 내역 화면'),
            ],
          ),
        )
    );
  }
}
