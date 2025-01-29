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
            top: MediaQuery.of(context).size.height * 0.18,
            left: 20,
            right: 20,
            child: Text(!controller.isScanning.value
                ? ''
                : 
              'จัดวัตถุให้อยู่ภายในกรอบเพื่อสแกน',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                      ElevatedButton(
                        onPressed: controller.resumeScanner,
                        style: ElevatedButton.styleFrom(
                          //backgroundColor: Colors.grey,
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: const Text('Re-Scan'),
                      ),
                      ElevatedButton(
                        onPressed: controller.continueToResult,
                        style: ElevatedButton.styleFrom(
                          //backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: const Text('Continue'),
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
