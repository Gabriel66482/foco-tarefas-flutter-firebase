import 'package:flutter_test/flutter_test.dart';
import 'package:foco_tarefas/models/tarefa.dart';

void main() {
  test('Model preserva todos os campos ao gravar e ler o banco', () {
    final original = Tarefa(
      id: 't1',
      titulo: 'Estudar Flutter',
      descricao: 'Revisar models',
      dataVencimento: DateTime(2026, 12, 10),
      prioridade: Prioridade.alta,
      concluida: false,
    );
    final recuperada = Tarefa.fromMap(original.id, original.toMap());
    expect(recuperada.id, original.id);
    expect(recuperada.titulo, original.titulo);
    expect(recuperada.descricao, original.descricao);
    expect(recuperada.dataVencimento, original.dataVencimento);
    expect(recuperada.prioridade, original.prioridade);
    expect(recuperada.concluida, isFalse);
    expect(recuperada.comSituacao(true).concluida, isTrue);
    expect(original.concluida, isFalse);
  });
}
