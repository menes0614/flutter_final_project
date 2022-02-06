import 'package:flutter/material.dart';

class PatientHomePage extends StatefulWidget {
  PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasta Ana Sayfa"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
