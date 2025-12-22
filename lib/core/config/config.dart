abstract class AppConfig {
  String get baseUrl;
}

class DevConfig implements AppConfig {
  @override
  String get baseUrl => "http://localhost:8000";
}

class ProdConfig implements AppConfig {
  @override
  String get baseUrl => "https://kahani-backend-wuj0.onrender.com";
}

class Environment {
  Environment._();

  static final Environment _instance = Environment._();

  factory Environment() => _instance;

  late AppConfig config;

  void initialize() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

    if (flavor == 'prod') {
      config = ProdConfig();
    } else {
      config = DevConfig();
    }
  }
}
