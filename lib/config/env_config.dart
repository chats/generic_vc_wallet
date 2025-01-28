class EnvConfig {
  static const Map<String, dynamic> devConfig = {
    'ws_url': 'ws://dev-server.com/ws',
    'api_url': 'https://dev-api.com',
    'debug_mode': true,
  };

  static const Map<String, dynamic> stagingConfig = {
    'ws_url': 'ws://staging-server.com/ws',
    'api_url': 'https://staging-api.com',
    'debug_mode': true,
  };

  static const Map<String, dynamic> prodConfig = {
    'ws_url': 'ws://prod-server.com/ws',
    'api_url': 'https://api.com',
    'debug_mode': false,
  };
}