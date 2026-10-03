import 'package:flutter/material.dart';

import '../data/auth/auth_controller.dart';
import 'escopo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  var _criando = false;
  var _ocupado = false;
  String? _erro;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final erroEmail = validarEmail(_email.text);
    final erroSenha = validarSenha(_senha.text);
    if (erroEmail != null || erroSenha != null) {
      setState(() => _erro = erroEmail ?? erroSenha);
      return;
    }
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      final auth = Escopo.of(context).auth;
      if (_criando) {
        await auth.cadastrar(_email.text, _senha.text);
      } else {
        await auth.entrar(_email.text, _senha.text);
      }
    } catch (erro) {
      if (mounted) setState(() => _erro = mensagemAuth(erro));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _criando ? 'Criar conta' : 'Entrar',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Reunião Marco Zero. Cada consultor vê só os próprios clientes.'),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _senha,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    onSubmitted: (_) => _ocupado ? null : _enviar(),
                  ),
                  if (_erro != null) ...[
                    const SizedBox(height: 12),
                    Text(_erro!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _ocupado ? null : _enviar,
                    child: Text(_ocupado ? 'Aguarde...' : (_criando ? 'Criar conta' : 'Entrar')),
                  ),
                  TextButton(
                    onPressed: _ocupado
                        ? null
                        : () => setState(() {
                            _criando = !_criando;
                            _erro = null;
                          }),
                    child: Text(_criando ? 'Já tenho conta' : 'Criar uma conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
