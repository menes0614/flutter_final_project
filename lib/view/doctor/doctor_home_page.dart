import 'package:flutter/material.dart';

class DoctorHomePage extends StatefulWidget {
  DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doktor Ana Sayfa"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
