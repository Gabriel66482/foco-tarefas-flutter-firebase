import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import 'helpers.dart';

class TarefaCard extends StatelessWidget {
  const TarefaCard({super.key, required this.tarefa, required this.onTap});
  final Tarefa tarefa;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final cor = switch (tarefa.prioridade) {
      Prioridade.alta => Colors.red,
      Prioridade.media => Colors.orange,
      Prioridade.baixa => Colors.teal,
    };
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          tarefa.concluida
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked,
          color: tarefa.concluida
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        title: Text(
          tarefa.titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vence em ${dataFormatada(tarefa.dataVencimento)}'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag_rounded, color: cor, size: 16),
                      const SizedBox(width: 4),
                      Text(tarefa.prioridade.label),
                    ],
                  ),
                  Text(tarefa.concluida ? 'Concluída' : 'Pendente'),
                  if (tarefa.atrasada)
                    Text(
                      'Atrasada',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
