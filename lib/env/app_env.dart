abstract class AppEnvironment {
  static String? headerKey;
  static String? baseApiUrl;
  static String? appname;
  static setupEnv(Environment env) {
    switch (env) {
      case Environment.dev:
        {
          headerKey = 'Authorization';
          baseApiUrl = 'https://api-todo-flutter.herokuapp.com';
          appname = "Yes broker";
          break;
        }
      case Environment.prod:
        {
          headerKey = 'Authorization';
          baseApiUrl = 'https://api-todo-flutter.herokuapp.com';
          appname = "Nirvaki";
          break;
        }
    }
  }
}

enum Environment { dev, prod }
