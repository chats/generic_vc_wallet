import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanController extends GetxController {}

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    //Get.lazyPut(() => ScanController());
  }
}

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สแกน QR'),
      ),
      body: Center(
        child: Text('สแกน QR'),
      ),
    );
  }
}