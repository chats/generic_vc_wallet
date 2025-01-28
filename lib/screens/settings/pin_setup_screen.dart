import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../services/storage_service.dart';

class PinSetupScreen extends StatefulWidget {
  @override
  _PinSetupScreenState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final StorageService _storage = Get.find<StorageService>();
  String _firstPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isConfirming ? 'ยืนยัน PIN' : 'ตั้งค่า PIN'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_isConfirming) {
              setState(() {
                _isConfirming = false;
                _firstPin = '';
                _pinController.clear();
              });
            } else {
              Get.back(result: false);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 40),
              Text(
                _isConfirming ? 'กรุณายืนยัน PIN อีกครั้ง' : 'กรุณาตั้ง PIN 6 หลัก',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  controller: _pinController,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: Theme.of(context).primaryColor,
                    selectedColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    if (_isConfirming) {
                      _handlePinConfirmation(value);
                    } else {
                      setState(() {
                        _firstPin = value;
                        _isConfirming = true;
                        _pinController.clear();
                      });
                    }
                  },
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 24),
              Text(
                _isConfirming
                    ? 'กรุณากรอก PIN เดิมอีกครั้งเพื่อยืนยัน'
                    : 'PIN ต้องเป็นตัวเลข 6 หลัก',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePinConfirmation(String confirmedPin) async {
    if (_firstPin == confirmedPin) {
      // Save PIN to secure storage
      await _storage.saveSecureData('pin_code', confirmedPin);
      Get.back(result: true);
      Get.snackbar(
        'สำเร็จ',
        'ตั้งค่า PIN เรียบร้อยแล้ว',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'ไม่สำเร็จ',
        'PIN ไม่ตรงกัน กรุณาลองใหม่',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      setState(() {
        _isConfirming = false;
        _firstPin = '';
        _pinController.clear();
      });
    }
  }
}