import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

class PreferenceSection extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'การตั้งค่า',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Obx(() => ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text('Dark Mode'),
            trailing: Switch(
              value: controller.isDarkMode.value,
              onChanged: controller.toggleDarkMode,
            ),
          )),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('การแจ้งเตือน'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}