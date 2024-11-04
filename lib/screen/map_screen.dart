import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(
          child: Column(
            children: [
              Text('주변 매장 화면'),
            ],
          ),
        )
    );
  }
}
