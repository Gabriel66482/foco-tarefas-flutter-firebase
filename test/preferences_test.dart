import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foco_tarefas/services/preferences_service.dart';

void main() {
  test('Tema é persistido e recuperado por uma nova instância', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = PreferencesService(prefs);
    expect(service.escuro, isFalse);
    await service.alterarTema(true);
    expect(PreferencesService(prefs).escuro, isTrue);
    await service.alterarTema(false);
    expect(PreferencesService(prefs).escuro, isFalse);
  });
}
