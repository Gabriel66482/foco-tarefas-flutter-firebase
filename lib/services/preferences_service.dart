import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  PreferencesService(this._preferences)
    : _escuro = _preferences.getBool('temaEscuro') ?? false;
  final SharedPreferences _preferences;
  bool _escuro;
  bool get escuro => _escuro;
  ThemeMode get mode => _escuro ? ThemeMode.dark : ThemeMode.light;

  Future<void> alterarTema(bool valor) async {
    // Só confirma a mudança depois que a preferência foi persistida.
    final salvo = await _preferences.setBool('temaEscuro', valor);
    if (!salvo) throw StateError('Não foi possível salvar o tema.');
    _escuro = valor;
    notifyListeners();
  }
}
