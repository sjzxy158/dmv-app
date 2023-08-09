import 'package:flutter/material.dart';

class HandbookPage extends StatefulWidget {
  const HandbookPage({Key? key}) : super(key: key);

  @override
  _HandbookPageState createState() => _HandbookPageState();
}

class _HandbookPageState extends State<HandbookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('handbook')),
    );
  }
}
