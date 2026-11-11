import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  const Usuario({required this.uid, required this.nome, required this.email});
  final String uid;
  final String nome;
  final String email;

  factory Usuario.fromFirebase(User user) => Usuario(
    uid: user.uid,
    nome: user.displayName?.trim().isNotEmpty == true
        ? user.displayName!
        : 'Usuário',
    email: user.email ?? '',
  );
}
