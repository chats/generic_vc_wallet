import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

class SecuritySection extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ความปลอดภัย',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Obx(() => ListTile(
            leading: Icon(Icons.pin_outlined),
            title: Text('PIN Code'),
            trailing: Switch(
              value: controller.isPinEnabled.value,
              onChanged: controller.togglePin,
            ),
          )),
          Obx(() => ListTile(
            leading: Icon(Icons.fingerprint),
            title: Text('Biometric'),
            trailing: Switch(
              value: controller.isBiometricEnabled.value,
              onChanged: controller.toggleBiometric,
            ),
          )),
        ],
      ),
    );
  }
}