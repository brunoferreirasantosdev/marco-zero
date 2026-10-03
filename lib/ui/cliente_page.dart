import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/local/banco.dart';
import '../data/script/roteiro.dart';
import 'escopo.dart';
import 'formatar.dart';
import 'tema.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({super.key, required this.id});

  final String id;

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  Cliente? _cliente;
  List<Reuniao> _reunioes = [];
  var _carregando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  Future<void> _prepararNova() async {
    final repo = Escopo.of(context).repositorio;
    final cliente = _cliente;
    if (repo == null || cliente == null) return;
    final reuniao = await repo.guardarReuniao(
      clienteId: cliente.id,
      perfil: null,
      expectativa: '',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );
    if (!mounted) return;
    await context.push('/reuniao/${reuniao.id}/etapas');
    _carregar();
  }

  Future<void> _carregar() async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null) return;
    final cliente = await repo.obterCliente(widget.id);
    final reunioes = await repo.listarReunioes(widget.id);
    if (!mounted) return;
    setState(() {
      _cliente = cliente;
      _reunioes = reunioes;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cliente = _cliente;
    return Scaffold(
      appBar: AppBar(
        title: Text(cliente?.nome ?? 'Cliente'),
        actions: [
          if (cliente != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: OutlinedButton(
                  style: _estiloNaBarra,
                  onPressed: _prepararNova,
                  child: const Text('Preparar reunião'),
                ),
              ),
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : cliente == null
          ? const Center(child: Text('Cliente não encontrado nesta conta.'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(cliente.email, style: Theme.of(context).textTheme.titleMedium),
                    if (cliente.telefone.isNotEmpty) Text(cliente.telefone),
                    const SizedBox(height: 20),
                    Text('Reuniões', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    if (_reunioes.isEmpty) const Text('Nenhuma reunião preparada. Use Preparar reunião.'),
                    for (final reuniao in _reunioes)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                perfilPorNome(reuniao.perfil)?.titulo ?? 'Perfil ainda não confirmado',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${formatarData(reuniao.updatedAt)} · ${reuniao.status == 'concluida' ? 'Concluída' : 'Pronta para executar'}',
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      await context.push('/reuniao/${reuniao.id}/etapas');
                                      _carregar();
                                    },
                                    child: const Text('Preparar'),
                                  ),
                                  FilledButton(
                                    onPressed: () async {
                                      await context.push('/reuniao/${reuniao.id}');
                                      _carregar();
                                    },
                                    child: const Text('Executar'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

final _estiloNaBarra = OutlinedButton.styleFrom(
  foregroundColor: carvao,
  backgroundColor: menta,
  side: const BorderSide(color: menta),
  shape: const StadiumBorder(),
);
