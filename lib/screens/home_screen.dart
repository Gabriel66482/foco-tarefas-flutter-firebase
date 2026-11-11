import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/tarefa.dart';
import '../services/app_services.dart';
import '../services/firebase_service.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/helpers.dart';
import '../widgets/tarefa_card.dart';
import 'cadastro_tarefa_screen.dart';
import 'configuracoes_screen.dart';
import 'detalhes_tarefa_screen.dart';
import 'tarefas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.services, required this.usuario});
  final AppServices services;
  final Usuario usuario;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Destino _destino = Destino.inicio;
  late final _service = FirebaseService(
    widget.services.database,
    widget.usuario.uid,
  );
  late final _stream = _service.observar();
  late final Stream<DatabaseEvent> _conexao = widget.services.database
      .ref('.info/connected')
      .onValue;

  void _abrir(Tarefa tarefa) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => DetalhesTarefaScreen(tarefa: tarefa, service: _service),
    ),
  );

  Future<void> _sair() async {
    try {
      await widget.services.auth.sair();
    } catch (error) {
      if (mounted) avisar(context, mensagemErro(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = switch (_destino) {
      Destino.inicio => 'Foco',
      Destino.tarefas => 'Minhas tarefas',
      Destino.configuracoes => 'Configurações',
      Destino.sobre => 'Sobre o aplicativo',
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          StreamBuilder<DatabaseEvent>(
            stream: _conexao,
            builder: (context, snapshot) {
              final conectado = snapshot.data?.snapshot.value == true;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Tooltip(
                  message: conectado
                      ? 'Conectado ao Realtime Database'
                      : 'Aguardando conexão com o banco',
                  child: Icon(
                    conectado
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                    color: conectado
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: DrawerMenu(
        usuario: widget.usuario,
        destino: _destino,
        onSelect: (destino) => setState(() => _destino = destino),
        onSair: _sair,
      ),
      floatingActionButton:
          _destino == Destino.inicio || _destino == Destino.tarefas
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => CadastroTarefaScreen(service: _service),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Nova tarefa'),
            )
          : null,
      body: switch (_destino) {
        Destino.configuracoes => ConfiguracoesScreen(services: widget.services),
        Destino.sobre => _sobre(context),
        _ => StreamBuilder<List<Tarefa>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    mensagemErro(snapshot.error!),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final tarefas = snapshot.data!;
            return _destino == Destino.tarefas
                ? TarefasScreen(tarefas: tarefas, onAbrir: _abrir)
                : _inicio(context, tarefas);
          },
        ),
      },
    );
  }

  Widget _inicio(BuildContext context, List<Tarefa> tarefas) {
    final concluidas = tarefas.where((t) => t.concluida).length;
    final pendentes = tarefas.length - concluidas;
    return SingleChildScrollView(
      child: Conteudo(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'Olá, ${widget.usuario.nome.split(' ').first}.',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              pendentes == 0
                  ? 'Tudo em dia. Que tal planejar seu próximo passo?'
                  : 'Um passo de cada vez. Você tem $pendentes tarefa(s) pendente(s).',
            ),
            const SizedBox(height: 28),
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final (titulo, valor, icone) in [
                    ('Cadastradas', tarefas.length, Icons.layers_outlined),
                    ('Pendentes', pendentes, Icons.schedule_rounded),
                    ('Concluídas', concluidas, Icons.task_alt_rounded),
                  ])
                    SizedBox(
                      width: constraints.maxWidth > 520
                          ? (constraints.maxWidth - 24) / 3
                          : constraints.maxWidth,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                icone,
                                size: 28,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$valor',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  Text(titulo),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Sua próxima conquista',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (tarefas.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Sua lista está pronta para começar.\nAdicione a primeira tarefa usando o botão abaixo.',
                  ),
                ),
              )
            else
              ...tarefas
                  .take(3)
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TarefaCard(tarefa: t, onTap: () => _abrir(t)),
                    ),
                  ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => setState(() => _destino = Destino.tarefas),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Ver todas as tarefas'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _sobre(BuildContext context) => SingleChildScrollView(
    child: Conteudo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 56),
          const SizedBox(height: 16),
          Text('Foco', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Suas tarefas, com mais clareza.\nVersão 1.0.0'),
          const SizedBox(height: 24),
          const Text(
            'Projeto P2 • Programação Mobile\nFlutter / Dart\nFirebase Authentication\nFirebase Realtime Database\nSharedPreferences',
          ),
          const SizedBox(height: 24),
          const Text(
            'Cada conta tem seu próprio espaço de tarefas. A autenticação mantém a sessão e as regras do banco protegem os dados por UID.',
          ),
          const SizedBox(height: 16),
          Text(
            widget.services.emuladores
                ? 'Ambiente: emuladores locais oficiais do Firebase.'
                : 'Ambiente: Firebase na nuvem.',
          ),
        ],
      ),
    ),
  );
}
