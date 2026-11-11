import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../widgets/helpers.dart';
import 'cadastro_tarefa_screen.dart';

class DetalhesTarefaScreen extends StatefulWidget {
  const DetalhesTarefaScreen({
    super.key,
    required this.tarefa,
    required this.service,
  });
  final Tarefa tarefa;
  final FirebaseService service;
  @override
  State<DetalhesTarefaScreen> createState() => _DetalhesTarefaScreenState();
}

class _DetalhesTarefaScreenState extends State<DetalhesTarefaScreen> {
  bool _ocupado = false;
  late final Stream<List<Tarefa>> _stream = widget.service.observar();

  Future<void> _alternar(Tarefa tarefa) async {
    setState(() => _ocupado = true);
    try {
      await widget.service.salvar(tarefa.comSituacao(!tarefa.concluida));
    } catch (error) {
      if (mounted) avisar(context, mensagemErro(error));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _excluir(Tarefa tarefa) async {
    final confirma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: Text(
          '“${tarefa.titulo}” será removida. Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirma != true || !mounted) return;
    setState(() => _ocupado = true);
    try {
      await widget.service.excluir(tarefa);
      if (mounted) {
        Navigator.pop(context);
        avisar(context, 'Tarefa excluída.');
      }
    } catch (error) {
      if (mounted) avisar(context, mensagemErro(error));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalhes da tarefa')),
    body: StreamBuilder<List<Tarefa>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(mensagemErro(snapshot.error!)));
        }
        final encontrados = snapshot.data?.where(
          (t) => t.id == widget.tarefa.id,
        );
        if (snapshot.hasData && encontrados!.isEmpty) {
          return const Center(
            child: Text('Esta tarefa foi excluída. Volte para a lista.'),
          );
        }
        final tarefa = encontrados?.firstOrNull ?? widget.tarefa;
        return SingleChildScrollView(
          child: Conteudo(
            width: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  tarefa.titulo,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  tarefa.descricao,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Vencimento'),
                  subtitle: Text(dataFormatada(tarefa.dataVencimento)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Prioridade'),
                  subtitle: Text(tarefa.prioridade.label),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.task_alt),
                  title: const Text('Situação'),
                  subtitle: Text(tarefa.concluida ? 'Concluída' : 'Pendente'),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _ocupado ? null : () => _alternar(tarefa),
                  icon: Icon(tarefa.concluida ? Icons.undo : Icons.check),
                  label: Text(
                    tarefa.concluida
                        ? 'Marcar como pendente'
                        : 'Concluir tarefa',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _ocupado
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => CadastroTarefaScreen(
                              service: widget.service,
                              tarefa: tarefa,
                            ),
                          ),
                        ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar tarefa'),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _ocupado ? null : () => _excluir(tarefa),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Excluir tarefa'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
