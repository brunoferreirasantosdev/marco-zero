import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._auth) {
    _assinatura = _auth?.authStateChanges().listen((usuario) {
      uid = usuario?.uid;
      notifyListeners();
    });
  }

  final FirebaseAuth? _auth;
  StreamSubscription<User?>? _assinatura;
  String? uid;

  bool get logado => uid != null;

  Future<void> entrar(String email, String senha) {
    return _auth!.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<void> cadastrar(String email, String senha) {
    return _auth!.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<void> sair() => _auth!.signOut();

  @override
  void dispose() {
    _assinatura?.cancel();
    super.dispose();
  }
}

String mensagemAuth(Object erro) {
  if (erro is FirebaseAuthException) {
    return switch (erro.code) {
      'invalid-email' => 'E-mail inválido.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'E-mail ou senha não conferem.',
      'email-already-in-use' => 'Já existe uma conta com este e-mail.',
      'weak-password' => 'A senha precisa ter pelo menos 6 caracteres.',
      'network-request-failed' => 'Sem conexão para entrar. Tente de novo.',
      _ => 'Não foi possível entrar (${erro.code}).',
    };
  }
  return 'Não foi possível entrar.';
}

String? validarEmail(String valor) {
  final texto = valor.trim();
  if (texto.isEmpty || !texto.contains('@') || !texto.contains('.')) {
    return 'Informe um e-mail válido.';
  }
  return null;
}

String? validarSenha(String valor) {
  if (valor.length < 6) return 'A senha precisa ter pelo menos 6 caracteres.';
  return null;
}
