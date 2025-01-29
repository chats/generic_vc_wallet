import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String scannedValue;

  const ResultScreen({Key? key, required this.scannedValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scanned Result:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              scannedValue,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}