import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

String dataFormatada(DateTime data) =>
    '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

String mensagemErro(Object error) {
  if (error is FirebaseException) {
    return switch (error.code) {
      'invalid-email' => 'Informe um e-mail válido.',
      'email-already-in-use' => 'Este e-mail já está cadastrado.',
      'weak-password' => 'A senha precisa ter pelo menos 6 caracteres.',
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'INVALID_LOGIN_CREDENTIALS' => 'E-mail ou senha incorretos.',
      'user-disabled' => 'Esta conta está desativada.',
      'too-many-requests' => 'Muitas tentativas. Aguarde e tente novamente.',
      'network-request-failed' =>
        'Sem conexão. Verifique a internet e tente novamente.',
      'permission-denied' || 'permission_denied' =>
        'Acesso negado. Verifique a sessão e as regras do banco.',
      'operation-not-allowed' =>
        'Habilite o login por e-mail e senha no Firebase Authentication.',
      _ =>
        'Não foi possível concluir a operação (${error.code}). Tente novamente.',
    };
  }
  return 'Não foi possível concluir a operação. Tente novamente.';
}

void avisar(BuildContext context, String mensagem) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(mensagem)));
}

class Conteudo extends StatelessWidget {
  const Conteudo({super.key, required this.child, this.width = 900});
  final Widget child;
  final double width;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  );
}
