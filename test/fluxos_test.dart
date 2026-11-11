import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foco_tarefas/models/tarefa.dart';
import 'package:foco_tarefas/screens/cadastro_tarefa_screen.dart';
import 'package:foco_tarefas/screens/tarefas_screen.dart';
import 'package:foco_tarefas/services/firebase_service.dart';

class BancoDeTeste extends Fake implements FirebaseService {
  Tarefa? salva;
  @override
  Future<void> salvar(Tarefa tarefa) async {
    salva = tarefa;
  }
}

Widget ambiente(Widget child) => MaterialApp(
  locale: const Locale('pt', 'BR'),
  supportedLocales: const [Locale('pt', 'BR')],
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  home: child,
);

void main() {
  testWidgets('Formulário impede salvar tarefa sem título e descrição', (
    tester,
  ) async {
    final banco = BancoDeTeste();
    await tester.pumpWidget(ambiente(CadastroTarefaScreen(service: banco)));
    await tester.ensureVisible(find.text('Salvar tarefa'));
    await tester.tap(find.text('Salvar tarefa'));
    await tester.pumpAndSettle();
    expect(find.text('Informe o título da tarefa.'), findsOneWidget);
    expect(find.text('Informe a descrição.'), findsOneWidget);
    expect(banco.salva, isNull);
  });

  testWidgets('Cadastro envia campos preenchidos e situação ao serviço', (
    tester,
  ) async {
    final banco = BancoDeTeste();
    await tester.pumpWidget(ambiente(CadastroTarefaScreen(service: banco)));
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Estudar Firebase',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Revisar regras por UID',
    );
    await tester.ensureVisible(find.byType(SwitchListTile));
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Salvar tarefa'));
    await tester.tap(find.text('Salvar tarefa'));
    await tester.pumpAndSettle();
    expect(banco.salva?.titulo, 'Estudar Firebase');
    expect(banco.salva?.descricao, 'Revisar regras por UID');
    expect(banco.salva?.concluida, isTrue);
    expect(banco.salva?.prioridade, Prioridade.media);
    expect(banco.salva?.id, '');
  });

  testWidgets('Edição preserva ID e envia o título alterado', (tester) async {
    final banco = BancoDeTeste();
    final tarefa = Tarefa(
      id: 'existente',
      titulo: 'Título anterior',
      descricao: 'Descrição',
      dataVencimento: DateTime(2026, 12, 1),
      prioridade: Prioridade.alta,
      concluida: false,
    );
    await tester.pumpWidget(
      ambiente(CadastroTarefaScreen(service: banco, tarefa: tarefa)),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Título revisado');
    await tester.ensureVisible(find.text('Salvar tarefa'));
    await tester.tap(find.text('Salvar tarefa'));
    await tester.pumpAndSettle();
    expect(banco.salva?.id, 'existente');
    expect(banco.salva?.titulo, 'Título revisado');
    expect(banco.salva?.prioridade, Prioridade.alta);
    expect(banco.salva?.dataVencimento, DateTime(2026, 12, 1));
  });

  testWidgets('ListView apresenta e filtra tarefas pela situação', (
    tester,
  ) async {
    final tarefas = [
      Tarefa(
        id: '1',
        titulo: 'Pendente de teste',
        descricao: 'Descrição',
        dataVencimento: DateTime(2026, 12, 1),
        prioridade: Prioridade.alta,
        concluida: false,
      ),
      Tarefa(
        id: '2',
        titulo: 'Concluída de teste',
        descricao: 'Descrição',
        dataVencimento: DateTime(2026, 12, 2),
        prioridade: Prioridade.baixa,
        concluida: true,
      ),
    ];
    Tarefa? selecionada;
    await tester.pumpWidget(
      ambiente(
        Scaffold(
          body: TarefasScreen(
            tarefas: tarefas,
            onAbrir: (tarefa) => selecionada = tarefa,
          ),
        ),
      ),
    );
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Pendente de teste'), findsOneWidget);
    expect(find.text('Concluída de teste'), findsOneWidget);
    await tester.tap(find.text('Pendentes'));
    await tester.pumpAndSettle();
    expect(find.text('Concluída de teste'), findsNothing);
    await tester.tap(find.text('Pendente de teste'));
    expect(selecionada?.id, '1');
    await tester.tap(find.text('Concluídas'));
    await tester.pumpAndSettle();
    expect(find.text('Pendente de teste'), findsNothing);
    expect(find.text('Concluída de teste'), findsOneWidget);
  });
}
