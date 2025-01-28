// services/websocket_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';

class WebSocketService extends GetxService {
  WebSocketChannel? _channel;
  final _reconnectDelay = const Duration(seconds: 5);
  Timer? _reconnectTimer;
  final _isConnected = false.obs;
  String? _apiKey;
  final FlutterLocalNotificationsPlugin _notificationPlugin = FlutterLocalNotificationsPlugin();
  
  // Getters
  bool get isConnected => _isConnected.value;
  Stream get stream => _channel?.stream ?? Stream.empty();

  Future<WebSocketService> init() async {
    // Initialize local notifications
    await _initializeNotifications();
    
    // Get API Key from secure storage
    final config = Get.find<AppConfig>();
    _apiKey = await config.wsApiKey;
    
    // Initial connection
    await connect();
    
    return this;
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
  }

  Future<void> _handleNotificationTap(NotificationResponse response) async {
    if (response.payload != null) {
      try {
        final payloadData = jsonDecode(response.payload!);
        // Handle navigation or action based on payload
        // Example: Get.toNamed('/details', arguments: payloadData);
      } catch (e) {
        print('Error handling notification tap: $e');
      }
    }
  }

  Future<void> connect() async {
    try {
      final config = Get.find<AppConfig>();
      final wsUrl = config.wsUrl;
      
      // Create connection URL with API Key
      final uri = Uri.parse(wsUrl).replace(
        queryParameters: {'api_key': _apiKey}
      );
      
      _channel = WebSocketChannel.connect(uri);
      _isConnected.value = true;

      // Send authentication message after connection
      _authenticate();

      // Listen to incoming messages
      _channel?.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _handleDisconnection();
        },
        onDone: () {
          print('WebSocket Connection Closed');
          _handleDisconnection();
        },
      );
    } catch (e) {
      print('WebSocket Connection Error: $e');
      _handleDisconnection();
    }
  }

  void _authenticate() {
    if (_apiKey != null && _isConnected.value) {
      sendMessage({
        'type': 'auth',
        'api_key': _apiKey,
      });
    }
  }

  void _handleDisconnection() {
    _isConnected.value = false;
    _channel?.sink.close();
    _channel = null;

    // Attempt to reconnect after delay
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, connect);
  }

  Future<void> _handleMessage(dynamic message) async {
    try {
      final Map<String, dynamic> data = jsonDecode(message);
      
      switch (data['type']) {
        case 'auth_success':
          print('Authentication successful');
          // Resubscribe to previous topics if needed
          break;
          
        case 'auth_error':
          print('Authentication failed: ${data['message']}');
          // Handle auth error (maybe try to refresh API key)
          await _handleAuthError();
          break;
          
        case 'notification':
          await showNotification(
            data['title'] ?? 'New Notification',
            data['body'] ?? '',
            data['payload'],
          );
          break;
          
        default:
          print('Unknown message type: ${data['type']}');
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  Future<void> _handleAuthError() async {
    // Try to get new API key from your auth service
    final config = Get.find<AppConfig>();
    _apiKey = await config.wsApiKey;
    
    if (_apiKey != null) {
      // Reconnect with new API key
      await connect();
    }
  }

  Future<void> showNotification(String title, String body, dynamic payload) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'websocket_notifications',
      'WebSocket Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: jsonEncode(payload),
    );
  }

  // Send message with automatically added API key
  void sendMessage(Map<String, dynamic> data) {
    if (_isConnected.value) {
      final message = {
        ...data,
        'api_key': _apiKey,
        'timestamp': DateTime.now().toIso8601String(),
      };
      _channel?.sink.add(jsonEncode(message));
    }
  }

  // Subscribe to topic
  void subscribe(String topic) {
    sendMessage({
      'type': 'subscribe',
      'topic': topic,
    });
  }

  // Unsubscribe from topic
  void unsubscribe(String topic) {
    sendMessage({
      'type': 'unsubscribe',
      'topic': topic,
    });
  }
  
  @override
  void onClose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    super.onClose();
  }
}