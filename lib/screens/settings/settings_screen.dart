import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import 'profile_section.dart';
import 'security_section.dart';
import 'preference_section.dart';


class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }
}

class SettingsScreen extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่า'),
        actions: [
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: () => _showResetConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Obx(() => ProfileSection(
                profileImage: controller.profileImageUrl.value,
                walletName: controller.walletName.value,
                onEditProfile: () => Get.toNamed('/settings/profile'),
              )),
              
              const SizedBox(height: 24),
              
              // Security Section
              SecuritySection(),
              
              const SizedBox(height: 24),
              
              // Preferences Section
              PreferenceSection(),
              
              const SizedBox(height: 24),
              
              // Terms and Reset Section
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.description_outlined),
                      title: Text('Term and Conditions'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => Get.toNamed('/settings/terms'),
                    ),
                    ListTile(
                      leading: Icon(Icons.restore, color: Colors.red),
                      title: Text('Reset All Data'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => _showResetConfirmation(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการรีเซ็ต'),
        content: Text('การดำเนินการนี้จะลบข้อมูลทั้งหมด คุณต้องการดำเนินการต่อหรือไม่?'),
        actions: [
          TextButton(
            child: Text('ยกเลิก'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('ยืนยัน', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              controller.resetAllData();
            },
          ),
        ],
      ),
    );
  }
}