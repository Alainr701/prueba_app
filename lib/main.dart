import 'package:flutter/material.dart';
import 'dart:async';

import 'package:prueba/page/location_page.dart';

void main() {
  runApp(LocalTimeApp());
}

class LocalTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationPage(),
    );
  }
}

class LocalTimePage extends StatefulWidget {
  @override
  _LocalTimePageState createState() => _LocalTimePageState();
}

class _LocalTimePageState extends State<LocalTimePage> {
  late Stream<String> timeStream;

  @override
  void initState() {
    super.initState();
    timeStream = Stream.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hora Local'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: StreamBuilder<String>(
          stream: timeStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Text(
              snapshot.data!,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            );
          },
        ),
      ),
    );
  }
}
