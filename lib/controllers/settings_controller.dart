
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final AuthService _authService = Get.find<AuthService>();

  // Profile
  final profileImageUrl = RxString('');
  final walletName = RxString('');
  final fullName = RxString('');
  final walletKey = RxString('');
  
  // Security
  final isPinEnabled = false.obs;
  final isBiometricEnabled = false.obs;
  final isBiometricAvailable = false.obs;
  final availableBiometrics = RxList<BiometricType>([]);
  
  // Preferences
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      // Check if hardware supports biometrics
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      if (canCheckBiometrics && isDeviceSupported) {
        // Get list of available biometrics
        final availableBiometricTypes = await _localAuth.getAvailableBiometrics();
        
        isBiometricAvailable.value = availableBiometricTypes.isNotEmpty;
        availableBiometrics.value = availableBiometricTypes;

        print('Available biometrics: $availableBiometricTypes');
      } else {
        isBiometricAvailable.value = false;
      }
    } catch (e) {
      print('Error checking biometric availability: $e');
      isBiometricAvailable.value = false;
    }
  }

  Future<void> _loadSettings() async {
    // Load profile
    profileImageUrl.value = _storage.getString('profile_image_url') ?? '';
    fullName.value = _storage.getString('full_name') ?? '';
    walletName.value = await _storage.getSecureData('wallet_name') ?? '';
    walletKey.value = await _storage.getSecureData('wallet_key') ?? '';
    
    // Load security settings
    isPinEnabled.value = _storage.getBool('pin_enabled') ?? false;
    isBiometricEnabled.value = _storage.getBool('biometric_enabled') ?? false;
    
    // Load preferences
    isDarkMode.value = _storage.getBool('dark_mode') ?? false;
  }

  // Profile Management
  Future<void> updateProfile({
    required String name,
    required String walletName,
    required String walletKey,
    String? imageUrl,
  }) async {
    // Save profile data
    await _storage.saveString('full_name', name);
    await _storage.saveSecureData('wallet_name', walletName);
    await _storage.saveSecureData('wallet_key', walletKey);
    
    if (imageUrl != null) {
      await _storage.saveString('profile_image_url', imageUrl);
      profileImageUrl.value = imageUrl;
    }
    
    // Update observable values
    fullName.value = name;
    this.walletName.value = walletName;
    this.walletKey.value = walletKey;
  }

  // Security Management
  Future<void> togglePin(bool value) async {
    if (value) {
      // Show PIN setup dialog
      final success = await Get.toNamed('/settings/pin-setup');
      if (success == true) {
        isPinEnabled.value = true;
        await _storage.saveBool('pin_enabled', true);
      }
    } else {
      // Verify current PIN before disabling
      final isAuthenticated = await _authService.authenticate();
      if (isAuthenticated) {
        isPinEnabled.value = false;
        await _storage.saveBool('pin_enabled', false);
        
        // Disable biometric if PIN is disabled
        if (isBiometricEnabled.value) {
          await toggleBiometric(false);
        }
        
        Get.snackbar(
          'สำเร็จ',
          'ปิดการใช้งาน PIN เรียบร้อยแล้ว',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // If authentication fails, revert the switch
        isPinEnabled.value = true;
        Get.snackbar(
          'ไม่สำเร็จ',
          'ไม่สามารถยืนยันตัวตนได้',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> toggleBiometric(bool value) async {
    try {
      if (value) {
        // Check if PIN is enabled (required for biometric)
        if (!isPinEnabled.value) {
          Get.snackbar(
            'แจ้งเตือน',
            'กรุณาตั้งค่า PIN ก่อนเปิดใช้งาน Biometric',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Check if biometric is available
        if (!isBiometricAvailable.value) {
          Get.snackbar(
            'แจ้งเตือน',
            'อุปกรณ์ของคุณไม่รองรับ Biometric',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Authenticate with biometric
        final didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'กรุณายืนยันตัวตนเพื่อเปิดใช้งาน Biometric',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (didAuthenticate) {
          isBiometricEnabled.value = true;
          await _storage.saveBool('biometric_enabled', true);
          Get.snackbar(
            'สำเร็จ',
            'เปิดใช้งาน Biometric เรียบร้อยแล้ว',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        isBiometricEnabled.value = false;
        await _storage.saveBool('biometric_enabled', false);
      }
    } catch (e) {
      print('Error toggling biometric: $e');
      if (e is PlatformException) {
        if (e.code == auth_error.notAvailable) {
          Get.snackbar(
            'แจ้งเตือน',
            'อุปกรณ์ของคุณไม่รองรับ Biometric',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else if (e.code == auth_error.notEnrolled) {
          Get.snackbar(
            'แจ้งเตือน',
            'กรุณาตั้งค่า Biometric ในการตั้งค่าอุปกรณ์ก่อน',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    }
  }

  // Preferences Management
  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    await _storage.saveBool('dark_mode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  // Reset All Data
  Future<void> resetAllData() async {
    await _storage.clearPrefs();
    await _storage.clearSecureStorage();
    
    // Reset observable values
    profileImageUrl.value = '';
    walletName.value = '';
    fullName.value = '';
    walletKey.value = '';
    isPinEnabled.value = false;
    isBiometricEnabled.value = false;
    isDarkMode.value = false;
    
    Get.offAllNamed('/');
  }
}