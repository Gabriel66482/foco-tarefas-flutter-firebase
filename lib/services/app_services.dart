import 'package:firebase_database/firebase_database.dart';
import 'auth_service.dart';
import 'preferences_service.dart';

class AppServices {
  const AppServices({
    required this.auth,
    required this.database,
    required this.preferences,
    required this.emuladores,
  });
  final AuthService auth;
  final FirebaseDatabase database;
  final PreferencesService preferences;
  final bool emuladores;
}
