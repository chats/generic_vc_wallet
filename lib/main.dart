import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/constants.dart';
import 'controllers/settings_controller.dart';
import 'screens/scanner/scanner_controller.dart';
import 'screens/scanner/scanner_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'services/websocket_service.dart';
import 'config/app_config.dart';
import 'screens/home/home_screen.dart';


// Initialize all services
Future<void> initServices() async {
  // Initialize StorageService first
  final storageService = await StorageService().init();
  Get.put(storageService);

  // Initialize AppConfig with StorageService
  final appConfig = AppConfig.instance;
  await appConfig.init(Environment.dev, storageService);
  Get.put(appConfig);

  // Initialize WebSocket Service last
  await Get.putAsync(() => WebSocketService().init());
}

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await initServices();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Generic VC Wallet',
      theme: ThemeData(
        primarySwatch: APP_PRIMARY_COLOR,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.anuphan().fontFamily,
      ),
      initialRoute: AppRoutes.home,
      initialBinding: AppBinding(),
      getPages: AppRoutes.routes,
      home: MainScreen(),
    ),
  );
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.lazyPut(() => NavigationController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ScannerController());
    Get.lazyPut(() => SettingsController());
  }
}

// Navigation Controller
class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  
  void changePage(int index) {
    currentIndex.value = index;
  }
}

class MainScreen extends GetView<NavigationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          HomeScreen(),
          ScannerScreen(),
          SettingsScreen(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'สแกน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
      )),
    );
  }
}
