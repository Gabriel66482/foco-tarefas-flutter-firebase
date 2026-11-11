import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../widgets/helpers.dart';

class CadastroTarefaScreen extends StatefulWidget {
  const CadastroTarefaScreen({super.key, required this.service, this.tarefa});
  final FirebaseService service;
  final Tarefa? tarefa;
  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descricao;
  late DateTime _data;
  late Prioridade _prioridade;
  late bool _concluida;
  bool _ocupado = false;
  @override
  void initState() {
    super.initState();
    final tarefa = widget.tarefa;
    _titulo = TextEditingController(text: tarefa?.titulo ?? '');
    _descricao = TextEditingController(text: tarefa?.descricao ?? '');
    final hoje = DateTime.now();
    _data = tarefa?.dataVencimento ?? DateTime(hoje.year, hoje.month, hoje.day);
    _prioridade = tarefa?.prioridade ?? Prioridade.media;
    _concluida = tarefa?.concluida ?? false;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descricao.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _ocupado = true);
    try {
      await widget.service.salvar(
        Tarefa(
          id: widget.tarefa?.id ?? '',
          titulo: _titulo.text.trim(),
          descricao: _descricao.text.trim(),
          dataVencimento: _data,
          prioridade: _prioridade,
          concluida: _concluida,
        ),
      );
      if (mounted) {
        Navigator.pop(context);
        avisar(context, 'Tarefa salva.');
      }
    } catch (error) {
      if (mounted) avisar(context, mensagemErro(error));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.tarefa == null ? 'Nova tarefa' : 'Editar tarefa'),
    ),
    body: SingleChildScrollView(
      child: Conteudo(
        width: 640,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Dê espaço ao que importa.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titulo,
                enabled: !_ocupado,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Informe o título da tarefa.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricao,
                enabled: !_ocupado,
                minLines: 3,
                maxLines: 5,
                maxLength: 2000,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Informe a descrição.'
                    : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _ocupado
                    ? null
                    : () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: _data,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100, 12, 31),
                        );
                        if (data != null && mounted) {
                          setState(() => _data = data);
                        }
                      },
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text('Vencimento: ${dataFormatada(_data)}'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Prioridade>(
                initialValue: _prioridade,
                decoration: const InputDecoration(labelText: 'Prioridade'),
                items: Prioridade.values
                    .map(
                      (p) => DropdownMenuItem(value: p, child: Text(p.label)),
                    )
                    .toList(),
                onChanged: _ocupado
                    ? null
                    : (value) => setState(() => _prioridade = value!),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Concluída'),
                subtitle: Text(
                  _concluida
                      ? 'Esta tarefa já foi finalizada.'
                      : 'Esta tarefa está pendente.',
                ),
                value: _concluida,
                onChanged: _ocupado
                    ? null
                    : (value) => setState(() => _concluida = value),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _ocupado ? null : _salvar,
                icon: const Icon(Icons.check_rounded),
                label: Text(_ocupado ? 'Salvando…' : 'Salvar tarefa'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
