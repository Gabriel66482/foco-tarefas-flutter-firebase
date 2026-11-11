import 'package:firebase_database/firebase_database.dart';
import '../models/tarefa.dart';

/// O UID vem da sessão, nunca de um campo editável da interface.
class FirebaseService {
  FirebaseService(FirebaseDatabase database, String uid)
    : _tarefas = database.ref('usuarios/$uid/tarefas');
  final DatabaseReference _tarefas;

  Stream<List<Tarefa>> observar() => _tarefas.onValue.map((event) {
    final tarefas = event.snapshot.children
        .map(
          (item) => Tarefa.fromMap(
            item.key!,
            Map<Object?, Object?>.from(item.value as Map),
          ),
        )
        .toList();
    tarefas.sort((a, b) {
      if (a.concluida != b.concluida) return a.concluida ? 1 : -1;
      final data = a.dataVencimento.compareTo(b.dataVencimento);
      return data != 0 ? data : a.id.compareTo(b.id);
    });
    return tarefas;
  });

  Future<void> salvar(Tarefa tarefa) async {
    final ref = tarefa.id.isEmpty ? _tarefas.push() : _tarefas.child(tarefa.id);
    await ref.set(tarefa.toMap());
  }

  Future<void> excluir(Tarefa tarefa) => _tarefas.child(tarefa.id).remove();
}
