import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  final bool isScanning;

  ScannerOverlay({required this.isScanning});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isScanning ? Colors.white : Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.65,
      height: size.width * 0.65,
    );

    // Draw background with hole
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(
            scanArea,
            const Radius.circular(0),
          )),
      ),
      backgroundPaint,
    );

    // Draw border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scanArea,
        const Radius.circular(0),
      ),
      borderPaint,
    );

    /*
    // Draw corner markers
    final markerLength = size.width * 0.05;
    final cornerPaint = Paint()
      ..color = isScanning ? Colors.white : Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Top left corner
    canvas.drawLine(
      Offset(scanArea.left, scanArea.top + markerLength),
      Offset(scanArea.left, scanArea.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.left, scanArea.top),
      Offset(scanArea.left + markerLength, scanArea.top),
      cornerPaint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(scanArea.right - markerLength, scanArea.top),
      Offset(scanArea.right, scanArea.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.right, scanArea.top),
      Offset(scanArea.right, scanArea.top + markerLength),
      cornerPaint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(scanArea.left, scanArea.bottom - markerLength),
      Offset(scanArea.left, scanArea.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.left, scanArea.bottom),
      Offset(scanArea.left + markerLength, scanArea.bottom),
      cornerPaint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(scanArea.right - markerLength, scanArea.bottom),
      Offset(scanArea.right, scanArea.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.right, scanArea.bottom - markerLength),
      Offset(scanArea.right, scanArea.bottom),
      cornerPaint,
    );
    */
  }

  @override
  bool shouldRepaint(covariant ScannerOverlay oldDelegate) {
    return oldDelegate.isScanning != isScanning;
  }
}
