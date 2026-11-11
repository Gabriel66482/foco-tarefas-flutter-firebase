import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';

class AuthService {
  AuthService(this.auth) {
    usuarios = auth.userChanges().map(
      (user) => user == null ? null : Usuario.fromFirebase(user),
    );
  }
  final FirebaseAuth auth;
  late final Stream<Usuario?> usuarios;

  Future<void> entrar(String email, String senha) async {
    await auth.signInWithEmailAndPassword(email: email.trim(), password: senha);
  }

  Future<void> cadastrar(String nome, String email, String senha) async {
    final credencial = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
    await credencial.user!.updateDisplayName(nome.trim());
    await credencial.user!.reload();
  }

  Future<void> sair() => auth.signOut();
}
