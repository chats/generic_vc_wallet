import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าหลัก'),
      ),
      body: Center(
        child: Text('หน้าหลัก'),
      ),
    );
  }
}