// config/app_config.dart

import 'package:get/get.dart';
import '../services/storage_service.dart';

enum Environment { dev, staging, prod }

class AppConfig extends GetxService {
  static final AppConfig instance = AppConfig._internal();
  AppConfig._internal();

  late Environment _environment;
  late StorageService _storageService;

  // Config Keys
  static const String _wsUrlKey = 'ws_url';
  static const String _wsApiKeyKey = 'ws_api_key';
  static const String _environmentKey = 'environment';

  // Default Values
  final Map<Environment, String> _wsUrls = {
    Environment.dev: 'ws://dev-server.com/ws',
    Environment.staging: 'ws://staging-server.com/ws',
    Environment.prod: 'ws://prod-server.com/ws',
  };

  // Initialize config
  Future<AppConfig> init(Environment env, StorageService storageService) async {
    _environment = env;
    _storageService = storageService;
    
    // Set default values if not exists
    if (!_storageService.hasKey(_wsUrlKey)) {
      await _storageService.saveString(_wsUrlKey, _wsUrls[env]!);
    }
    
    // Save environment
    await _storageService.saveString(_environmentKey, env.toString());
    
    return this;
  }

  // Getters
  String get wsUrl => _storageService.getString(_wsUrlKey) ?? _wsUrls[_environment]!;
  
  Future<String?> get wsApiKey async => 
    await _storageService.getSecureData(_wsApiKeyKey);
  
  Environment get environment {
    final envStr = _storageService.getString(_environmentKey);
    return Environment.values.firstWhere(
      (e) => e.toString() == envStr,
      orElse: () => Environment.dev
    );
  }

  // Setters
  Future<void> setWsUrl(String url) async {
    await _storageService.saveString(_wsUrlKey, url);
  }

  Future<void> setWsApiKey(String apiKey) async {
    await _storageService.saveSecureData(_wsApiKeyKey, apiKey);
  }

  // Clear all config
  Future<void> clearConfig() async {
    await _storageService.clearPrefs();
    await _storageService.clearSecureStorage();
  }
}