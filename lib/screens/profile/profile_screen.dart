import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    //Get.lazyPut(() => ProfileController());
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์'),
      ),
      body: Center(
        child: Text('โปรไฟล์'),
      ),
    );
  }
}