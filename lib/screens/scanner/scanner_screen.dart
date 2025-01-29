import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'scanner_controller.dart';
import 'scanner_overlay.dart';


class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScannerController());
  }
}


class ScannerScreen extends GetView<ScannerController> {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.torchState.value 
                      ? Icons.flash_on
                      : Icons.flash_off,
                ),
                onPressed: controller.toggleTorch,
              )),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.mobileScannerController,
            onDetect: controller.onDetect,
          ),
          Obx(() => CustomPaint(
            painter: ScannerOverlay(
              isScanning: controller.isScanning.value,
            ),
            child: const SizedBox.expand(),
          )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.185,
            left: 20,
            right: 20,
            child: !controller.isScanning.value ? Container() : Text(
              'จัดวัตถุให้อยู่ภายในกรอบเพื่อสแกน',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Control buttons
          Obx(() => !controller.isScanning.value
              ? Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: controller.resumeScanner,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.8), width: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          'Re-Scan',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.continueToResult,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          //side: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.8), width: 2),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}