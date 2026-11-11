import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/usuario.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/app_services.dart';
import 'services/auth_service.dart';
import 'services/firebase_config.dart';
import 'services/preferences_service.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: FirebaseConfig.options);
    final auth = FirebaseAuth.instance;
    final database = FirebaseDatabase.instance;
    if (FirebaseConfig.emuladores) {
      await auth.useAuthEmulator(FirebaseConfig.host, 9099);
      database.useDatabaseEmulator(FirebaseConfig.host, 9000);
    }
    if (kIsWeb) await auth.setPersistence(Persistence.LOCAL);
    final preferences = PreferencesService(
      await SharedPreferences.getInstance(),
    );
    runApp(
      FocoApp(
        services: AppServices(
          auth: AuthService(auth),
          database: database,
          preferences: preferences,
          emuladores: FirebaseConfig.emuladores,
        ),
      ),
    );
  } catch (error) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: SelectableText(
                'Não foi possível iniciar o Foco.\n\n$error\n\nConsulte o README do projeto.',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FocoApp extends StatelessWidget {
  const FocoApp({super.key, required this.services});
  final AppServices services;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: services.preferences,
    builder: (context, _) => MaterialApp(
      title: 'Foco • suas tarefas',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: services.preferences.mode,
      home: StreamBuilder<Usuario?>(
        stream: services.auth.usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Falha ao verificar a sessão. Reabra o aplicativo.',
                ),
              ),
            );
          }
          final usuario = snapshot.data;
          return usuario == null
              ? LoginScreen(services: services)
              : HomeScreen(
                  key: ValueKey(usuario.uid),
                  services: services,
                  usuario: usuario,
                );
        },
      ),
    ),
  );
}
