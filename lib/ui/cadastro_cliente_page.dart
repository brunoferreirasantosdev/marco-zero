import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'escopo.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key, this.clienteId});

  final String? clienteId;

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _nome = TextEditingController();
  final _telefone = TextEditingController();
  final _email = TextEditingController();
  var _salvando = false;
  String? _aviso;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _preencher());
  }

  Future<void> _preencher() async {
    final id = widget.clienteId;
    if (id == null) return;
    final repo = Escopo.of(context).repositorio;
    final cliente = await repo?.obterCliente(id);
    if (cliente == null || !mounted) return;
    _nome.text = cliente.nome;
    _telefone.text = cliente.telefone;
    _email.text = cliente.email;
  }

  @override
  void dispose() {
    _nome.dispose();
    _telefone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null) return;
    if (_nome.text.trim().isEmpty) {
      setState(() => _aviso = 'Informe o nome do cliente.');
      return;
    }
    setState(() {
      _salvando = true;
      _aviso = null;
    });
    try {
      await repo.garantirCliente(
        id: widget.clienteId,
        nome: _nome.text,
        telefone: _telefone.text,
        email: _email.text,
      );
      if (!mounted) return;
      context.pop(true);
    } catch (_) {
      if (mounted) setState(() => _aviso = 'Não foi possível salvar agora.');
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clienteId == null ? 'Cadastrar cliente' : 'Editar cliente'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (_aviso != null) ...[
                Text(_aviso!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 12),
              ],
              TextField(controller: _nome, decoration: const InputDecoration(labelText: 'Nome do cliente')),
              const SizedBox(height: 8),
              TextField(controller: _telefone, decoration: const InputDecoration(labelText: 'Telefone')),
              const SizedBox(height: 8),
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'E-mail')),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _salvando ? null : _salvar,
                child: Text(_salvando ? 'Salvando...' : widget.clienteId == null ? 'Cadastrar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
