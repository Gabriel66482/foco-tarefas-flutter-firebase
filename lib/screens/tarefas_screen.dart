import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../widgets/tarefa_card.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({
    super.key,
    required this.tarefas,
    required this.onAbrir,
  });
  final List<Tarefa> tarefas;
  final ValueChanged<Tarefa> onAbrir;
  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  int _filtro = 0;
  @override
  Widget build(BuildContext context) {
    final lista = widget.tarefas
        .where(
          (t) => _filtro == 0 || (_filtro == 1 ? !t.concluida : t.concluida),
        )
        .toList();
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (indice, titulo) in [
                    (0, 'Todas'),
                    (1, 'Pendentes'),
                    (2, 'Concluídas'),
                  ])
                    ChoiceChip(
                      label: Text(titulo),
                      selected: _filtro == indice,
                      onSelected: (_) => setState(() => _filtro = indice),
                    ),
                ],
              ),
            ),
            Expanded(
              child: lista.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Nenhuma tarefa por aqui.\nUse “Nova tarefa” para começar.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: lista.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) => TarefaCard(
                        tarefa: lista[index],
                        onTap: () => widget.onAbrir(lista[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
