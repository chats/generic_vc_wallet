import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';

import 'result_screen.dart';

class ScannerController extends GetxController with WidgetsBindingObserver {
  final isScanning = true.obs;
  final torchState = false.obs;
  final scannedValue = RxString('');
  MobileScannerController? mobileScannerController;
  Rx<Uint8List?> lastFrame = Rx<Uint8List?>(null);

  @override
  void onInit() {
    super.onInit();
    initializeScanner();
    WidgetsBinding.instance.addObserver(this);
    
    // Monitor route changes using GetX
    ever(Get.routing.current.obs, (String route) {
      if (route != '/scanner') {
        stopScanner();
      } else {
        startScanner();
      }
    });
  }

  @override
  void onClose() {
    disposeScanner();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mobileScannerController!.value.hasCameraPermission) {
      return;
    }
    print('Current route: ${Get.currentRoute}');
    
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        print('App is in the background');
        stopScanner();
        break;
      case AppLifecycleState.resumed:
        print('App is in the foreground');
        startScanner();
        break;
    }
  }

  void initializeScanner() {
    mobileScannerController = MobileScannerController(
      returnImage: true,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  void disposeScanner() {
    lastFrame.value = null;
    mobileScannerController?.dispose();
    mobileScannerController = null;
  }

  void stopScanner() {
    mobileScannerController?.stop();
  }

  void startScanner() {
    if (mobileScannerController == null) {
      initializeScanner();
    }
    mobileScannerController?.start();
    isScanning.value = true;
    scannedValue.value = '';
  }

  void toggleTorch() {
    mobileScannerController?.toggleTorch();
    torchState.toggle();
  }

  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    lastFrame.value = capture.image;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null && isScanning.value) {
        scannedValue.value = barcode.rawValue!;
        isScanning.value = false;
        mobileScannerController?.stop();
      }
    }
  }

  void resumeScanner() {
    lastFrame.value = null;
    startScanner();
  }

  void continueToResult() {
    Get.to(() => ResultScreen(scannedValue: scannedValue.value));
  }
}