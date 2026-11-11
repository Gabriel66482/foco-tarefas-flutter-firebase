import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const emuladores = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
  static const host = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );
  static FirebaseOptions get options {
    if (emuladores) {
      return const FirebaseOptions(
        apiKey: 'demo-api-key',
        appId: '1:123456789:web:demo',
        messagingSenderId: '123456789',
        projectId: 'demo-foco-tarefas',
        authDomain: 'demo-foco-tarefas.firebaseapp.com',
        databaseURL: 'https://demo-foco-tarefas-default-rtdb.firebaseio.com',
      );
    }
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const databaseURL = String.fromEnvironment('FIREBASE_DATABASE_URL');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    if ([projectId, apiKey, databaseURL, appId].any((value) => value.isEmpty)) {
      throw StateError(
        'Configuração Firebase ausente. Execute com '
        '--dart-define-from-file=config/firebase.json ou use a configuração de emuladores.',
      );
    }
    return const FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      projectId: projectId,
      databaseURL: databaseURL,
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    );
  }
}
