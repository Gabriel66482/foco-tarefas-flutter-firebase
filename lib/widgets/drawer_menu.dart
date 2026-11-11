import 'package:flutter/material.dart';
import '../models/usuario.dart';

enum Destino { inicio, tarefas, configuracoes, sobre }

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
    required this.usuario,
    required this.destino,
    required this.onSelect,
    required this.onSair,
  });
  final Usuario usuario;
  final Destino destino;
  final ValueChanged<Destino> onSelect;
  final VoidCallback onSair;
  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(usuario.nome),
            accountEmail: Text(usuario.email),
            currentAccountPicture: CircleAvatar(
              child: Text(usuario.nome.substring(0, 1).toUpperCase()),
            ),
          ),
          for (final (item, titulo, icone) in [
            (Destino.inicio, 'Início', Icons.space_dashboard_outlined),
            (Destino.tarefas, 'Minhas tarefas', Icons.checklist_rounded),
            (Destino.configuracoes, 'Configurações', Icons.settings_outlined),
            (Destino.sobre, 'Sobre o aplicativo', Icons.info_outline),
          ])
            ListTile(
              selected: destino == item,
              leading: Icon(icone),
              title: Text(titulo),
              onTap: () {
                Navigator.pop(context);
                onSelect(item);
              },
            ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              onSair();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Foco • versão 1.0.0'),
          ),
        ],
      ),
    ),
  );
}
