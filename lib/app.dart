import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/auth/auth_controller.dart';
import 'data/local/banco.dart';
import 'ui/atualizacao_host.dart';
import 'ui/cadastro_cliente_page.dart';
import 'ui/cliente_page.dart';
import 'ui/clientes_page.dart';
import 'ui/config_page.dart';
import 'ui/escopo.dart';
import 'ui/login_page.dart';
import 'ui/preferencias_page.dart';
import 'ui/reuniao_page.dart';
import 'ui/tema.dart';

class MarcoZeroApp extends StatefulWidget {
  const MarcoZeroApp({
    super.key,
    required this.banco,
    required this.firebasePronto,
    this.authFirebase,
    this.firestore,
  });

  final AppDatabase banco;
  final bool firebasePronto;
  final FirebaseAuth? authFirebase;
  final FirebaseFirestore? firestore;

  @override
  State<MarcoZeroApp> createState() => _MarcoZeroAppState();
}

class _MarcoZeroAppState extends State<MarcoZeroApp> {
  late final AuthController _auth;
  late final Sessao _sessao;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _auth = AuthController(widget.authFirebase);
    _sessao = Sessao(auth: _auth, banco: widget.banco, firestore: widget.firestore)..iniciar();
    _router = GoRouter(
      refreshListenable: _auth,
      initialLocation: widget.firebasePronto ? '/login' : '/config',
      redirect: (context, state) {
        final lugar = state.matchedLocation;
        if (!widget.firebasePronto) {
          return lugar == '/config' ? null : '/config';
        }
        if (!_auth.logado) return lugar == '/login' ? null : '/login';
        if (lugar == '/login' || lugar == '/config') return '/clientes';
        return null;
      },
      routes: [
        GoRoute(path: '/config', builder: (_, _) => const ConfigPage()),
        GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
        GoRoute(path: '/preferencias', builder: (_, _) => const PreferenciasPage()),
        GoRoute(
          path: '/clientes',
          builder: (_, _) => const ClientesPage(),
          routes: [
            GoRoute(path: 'novo', builder: (_, _) => const CadastroClientePage()),
            GoRoute(
              path: ':id',
              builder: (_, state) => ClientePage(id: state.pathParameters['id']!),
              routes: [
                GoRoute(
                  path: 'editar',
                  builder: (_, state) => CadastroClientePage(clienteId: state.pathParameters['id']),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/nova',
          builder: (_, state) => ReuniaoPage(clienteId: state.uri.queryParameters['clienteId']),
        ),
        GoRoute(
          path: '/reuniao/:id/etapas',
          builder: (_, state) => ReuniaoPage(
            reuniaoId: state.pathParameters['id'],
            preparando: true,
          ),
        ),
        GoRoute(
          path: '/reuniao/:id',
          builder: (_, state) => ReuniaoPage(reuniaoId: state.pathParameters['id']),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _sessao.dispose();
    _auth.dispose();
    widget.banco.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Escopo(
      sessao: _sessao,
      child: MaterialApp.router(
        title: 'Reunião Marco Zero',
        theme: temaMarcoZero(),
        routerConfig: _router,
        builder: (context, child) => AtualizacaoHost(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
