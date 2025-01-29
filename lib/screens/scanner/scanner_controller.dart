import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'result_screen.dart';

class ScannerController extends GetxController {
  final isScanning = true.obs;
  final torchState = false.obs;
  final scannedValue = RxString('');
  MobileScannerController? mobileScannerController;

  @override
  void onInit() {
    super.onInit();
    mobileScannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void onClose() {
    mobileScannerController?.dispose();
    super.onClose();
  }

  void toggleTorch() {
    mobileScannerController?.toggleTorch();
    torchState.toggle();
  }

  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && isScanning.value) {
        scannedValue.value = barcode.rawValue!;
        isScanning.value = false;
        mobileScannerController?.pause();
      }
    }
  }

  void resumeScanner() {
    scannedValue.value = '';
    isScanning.value = true;
    mobileScannerController?.start();
  }

  void continueToResult() {
    Get.to(() => ResultScreen(scannedValue: scannedValue.value));
  }
}