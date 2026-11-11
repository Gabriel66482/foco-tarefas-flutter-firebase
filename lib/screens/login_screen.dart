import 'package:flutter/material.dart';
import '../services/app_services.dart';
import '../widgets/helpers.dart';
import 'cadastro_usuario_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.services});
  final AppServices services;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _ocupado = false;
  bool _ocultar = true;
  String? _erro;
  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      await widget.services.auth.entrar(_email.text, _senha.text);
    } catch (error) {
      if (mounted) setState(() => _erro = mensagemErro(error));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Conteudo(
            width: 480,
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Foco',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Menos pendências. Mais tranquilidade.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Bem-vindo de volta',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Entre para cuidar das suas tarefas.'),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    enabled: !_ocupado,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
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
                    obscureText: _ocultar,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _ocultar ? 'Mostrar senha' : 'Ocultar senha',
                        onPressed: () => setState(() => _ocultar = !_ocultar),
                        icon: Icon(
                          _ocultar
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe a senha.'
                        : null,
                    onFieldSubmitted: (_) {
                      if (!_ocupado) _entrar();
                    },
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
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _ocupado ? null : _entrar,
                    child: Text(_ocupado ? 'Entrando…' : 'Entrar'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _ocupado
                        ? null
                        : () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => CadastroUsuarioScreen(
                                services: widget.services,
                              ),
                            ),
                          ),
                    child: const Text('Criar minha conta'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.services.emuladores
                        ? 'Ambiente local • Firebase Emulator Suite'
                        : 'Suas tarefas sincronizadas com Firebase',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe o e-mail.';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) {
    return 'Informe um e-mail válido.';
  }
  return null;
}
