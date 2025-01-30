import 'package:generic_vc_wallet/screens/scanner/scanner_screen.dart';
import 'package:get/get.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/license_agreement_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/profile_edit_screen.dart';
import 'screens/settings/pin_setup_screen.dart';
import 'screens/settings/terms_screen.dart';

class AppRoutes {
  // Route names
  static const String home = '/';
  static const String scanner = '/scanner';
  static const String settings = '/settings';
  static const String profileEdit = '/settings/profile';
  static const String pinSetup = '/settings/pin-setup';
  static const String terms = '/settings/terms';
  static const String license = '/settings/license';
  
  
  // Get pages
  static final routes = [
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: scanner,
      page: () => ScannerScreen(),
      binding: ScannerBinding(),
    ),
    GetPage(
      name: settings,
      page: () => SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: profileEdit,
      page: () => ProfileEditScreen(),
//      binding: ProfileEditBinding(),
    ),
    GetPage(
      name: pinSetup,
      page: () => PinSetupScreen(),
//      binding: PinSetupBinding(),
    ),
    GetPage(
      name: terms,
      page: () => TermsScreen(),
//      binding: TermsBinding(),
    ),
    GetPage(
      name: license,
      page: () => LicenseScreen(),
//      binding: LicenseBinding(),
    )
  ];
}