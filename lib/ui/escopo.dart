import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../data/auth/auth_controller.dart';
import '../data/local/banco.dart';
import '../data/preferencias.dart';
import '../data/reuniao_repository.dart';
import '../data/sync/firestore_sync.dart';

class Sessao extends ChangeNotifier {
  Sessao({
    required this.auth,
    required this.banco,
    this.firestore,
  });

  final AuthController auth;
  final AppDatabase banco;
  final FirebaseFirestore? firestore;
  Repositorio? repositorio;
  String? avisoSync;
  Preferencias preferencias = Preferencias.padrao;

  void iniciar() {
    auth.addListener(_aoAuth);
    _aoAuth();
  }

  Future<void> _aoAuth() async {
    final uid = auth.uid;
    if (uid == null) {
      repositorio = null;
      avisoSync = null;
      preferencias = Preferencias.padrao;
      notifyListeners();
      return;
    }
    final repo = Repositorio(
      banco: banco,
      uid: uid,
      remoto: firestore == null ? null : FirestoreSync(firestore!),
    );
    repositorio = repo;
    preferencias = await repo.obterPreferencias();
    notifyListeners();
    final aviso = await repo.sincronizar();
    if (auth.uid != uid) return;
    avisoSync = aviso;
    notifyListeners();
  }

  Future<void> guardarPreferencias(Preferencias valor) async {
    await repositorio?.salvarPreferencias(valor);
    preferencias = valor;
    notifyListeners();
  }

  @override
  void dispose() {
    auth.removeListener(_aoAuth);
    super.dispose();
  }
}

class Escopo extends InheritedNotifier<Sessao> {
  const Escopo({super.key, required Sessao sessao, required super.child}) : super(notifier: sessao);

  static Sessao of(BuildContext context) {
    final escopo = context.dependOnInheritedWidgetOfExactType<Escopo>();
    assert(escopo != null, 'Escopo ausente');
    return escopo!.notifier!;
  }
}
