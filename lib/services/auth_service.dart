import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final StorageService _storage = Get.find<StorageService>();

  Future<bool> authenticate() async {
    final isBiometricEnabled = _storage.getBool('biometric_enabled') ?? false;
    final isPinEnabled = _storage.getBool('pin_enabled') ?? false;

    if (!isPinEnabled && !isBiometricEnabled) {
      return true; // ถ้าไม่ได้ตั้งค่าการรักษาความปลอดภัยใดๆ ให้ผ่านไปได้เลย
    }

    if (isBiometricEnabled) {
      try {
        final didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'กรุณายืนยันตัวตนเพื่อดำเนินการต่อ',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        return didAuthenticate;
      } catch (e) {
        // ถ้า biometric ไม่สำเร็จให้ใช้ PIN แทน
        return await _authenticateWithPin();
      }
    } else {
      return await _authenticateWithPin();
    }
  }

  Future<bool> _authenticateWithPin() async {
    final savedPin = await _storage.getSecureData('pin_code');
    if (savedPin == null) return false;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text('ยืนยัน PIN'),
        content: _PinInputDialog(),
      ),
    );

    return result ?? false;
  }
}

class _PinInputDialog extends StatefulWidget {
  @override
  _PinInputDialogState createState() => _PinInputDialogState();
}

class _PinInputDialogState extends State<_PinInputDialog> {
  final _pinController = TextEditingController();
  final _storage = Get.find<StorageService>();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _pinController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'กรุณากรอก PIN 6 หลัก',
            errorText: _errorText,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: _verifyPin,
              child: Text('ยืนยัน'),
            ),
          ],
        ),
      ],
    );
  }

  void _verifyPin() async {
    final savedPin = await _storage.getSecureData('pin_code');
    if (_pinController.text == savedPin) {
      Get.back(result: true);
    } else {
      setState(() {
        _errorText = 'PIN ไม่ถูกต้อง';
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}