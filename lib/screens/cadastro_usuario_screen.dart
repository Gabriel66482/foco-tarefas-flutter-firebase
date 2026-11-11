import 'package:flutter/material.dart';
import '../services/app_services.dart';
import '../widgets/helpers.dart';
import 'login_screen.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key, required this.services});
  final AppServices services;
  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _ocupado = false;
  String? _erro;
  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      await widget.services.auth.cadastrar(
        _nome.text,
        _email.text,
        _senha.text,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) setState(() => _erro = mensagemErro(error));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Criar conta')),
    body: SingleChildScrollView(
      child: Conteudo(
        width: 480,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(
                'Um novo começo.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Organize o que importa, um passo de cada vez.'),
              const SizedBox(height: 28),
              TextFormField(
                controller: _nome,
                enabled: !_ocupado,
                maxLength: 80,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => (value?.trim().length ?? 0) < 2
                    ? 'Informe seu nome (mínimo 2 caracteres).'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                enabled: !_ocupado,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                validator: validarEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senha,
                enabled: !_ocupado,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  helperText: 'Pelo menos 6 caracteres',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) => (value?.length ?? 0) < 6
                    ? 'Use pelo menos 6 caracteres.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: !_ocupado,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) =>
                    value != _senha.text ? 'As senhas não coincidem.' : null,
              ),
              if (_erro != null) ...[
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _erro!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _ocupado ? null : _cadastrar,
                child: Text(_ocupado ? 'Criando conta…' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
