import 'package:flutter/material.dart';
import '../services/app_services.dart';
import '../widgets/helpers.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key, required this.services});
  final AppServices services;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Conteudo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do seu jeito',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text('Uma aparência confortável para a sua rotina.'),
          const SizedBox(height: 24),
          Card(
            child: ListenableBuilder(
              listenable: services.preferences,
              builder: (context, _) => SwitchListTile(
                title: const Text('Tema escuro'),
                subtitle: const Text('Sua escolha é salva neste dispositivo.'),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: services.preferences.escuro,
                onChanged: (value) async {
                  try {
                    await services.preferences.alterarTema(value);
                  } catch (error) {
                    if (context.mounted) {
                      avisar(context, mensagemErro(error));
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Conexão', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            services.emuladores
                ? 'Emuladores oficiais do Firebase. Os dados estão neste computador.'
                : 'Firebase Authentication e Realtime Database na nuvem.',
          ),
        ],
      ),
    ),
  );
}
