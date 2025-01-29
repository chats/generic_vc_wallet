import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller
class HomeController extends GetxController {
  void test() {
    print('Test Home Controller');
  }
}

//Bindings
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.test();
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