// screens/settings/profile_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../services/auth_service.dart';

class ProfileEditScreen extends GetView<SettingsController> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _walletNameController = TextEditingController();
  final _walletKeyController = TextEditingController();
  final _authService = Get.find<AuthService>();

  ProfileEditScreen() {
    _initializeScreen();
  }

  void _initializeScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ตรวจสอบ authentication ก่อนแสดงหน้าจอ
      final isAuthenticated = await _authService.authenticate();
      if (!isAuthenticated) {
        Get.back();
        Get.snackbar(
          'แจ้งเตือน',
          'ไม่สามารถยืนยันตัวตนได้',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // โหลดข้อมูลหลังจาก authenticate สำเร็จ
      _nameController.text = controller.fullName.value;
      _walletNameController.text = controller.walletName.value;
      _walletKeyController.text = controller.walletKey.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขโปรไฟล์'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image Preview
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() => CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.profileImageUrl.value.isNotEmpty
                          ? NetworkImage(controller.profileImageUrl.value)
                          : AssetImage(
                              _getDefaultAvatarPath(controller.fullName.value)
                            ) as ImageProvider,
                    )),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อ-นามสกุล *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อ-นามสกุล';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Wallet Name Field
                TextFormField(
                  controller: _walletNameController,
                  decoration: InputDecoration(
                    labelText: 'Wallet Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    helperText: 'ภาษาอังกฤษเท่านั้น',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอก Wallet Name';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                      return 'กรุณาใช้ภาษาอังกฤษและตัวเลขเท่านั้น';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Wallet Key Field
                TextFormField(
                  controller: _walletKeyController,
                  decoration: InputDecoration(
                    labelText: 'Wallet Key *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.content_paste),
                      onPressed: () async {
                        // Implement paste from clipboard
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอก Wallet Key';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveProfile,
                    child: Text('บันทึก'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDefaultAvatarPath(String? name) {
    //final isMan = name?.toLowerCase().contains('man') ?? false || 
    //              name!.toLowerCase().contains('boy');
    //return isMan 
    //    ? 'assets/images/avatar-man-500.png' 
    //    : 'assets/images/avatar-woman-500.png';
    return 'assets/images/avatar-man-500.png';
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      controller.updateProfile(
        name: _nameController.text,
        walletName: _walletNameController.text,
        walletKey: _walletKeyController.text,
        imageUrl: null, // ไม่ใช้ URL รูปภาพแล้ว
      );
      Get.back();
      Get.snackbar(
        'สำเร็จ',
        'บันทึกข้อมูลโปรไฟล์เรียบร้อยแล้ว',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}