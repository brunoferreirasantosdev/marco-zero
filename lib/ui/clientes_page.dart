import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/local/banco.dart';
import 'atualizacao_host.dart';
import 'escopo.dart';
import 'tema.dart';

class _CabecalhoClientes extends StatelessWidget {
  const _CabecalhoClientes();

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Cliente', style: estilo)),
          Expanded(flex: 3, child: Text('Contato', style: estilo)),
          Expanded(
            flex: 6,
            child: Text('Ações', style: estilo, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _busca = TextEditingController();
  List<Cliente> _clientes = [];
  var _carregando = true;
  GoRouterDelegate? _delegado;

  @override
  void initState() {
    super.initState();
    _busca.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final delegado = GoRouter.of(context).routerDelegate;
    if (_delegado == delegado) return;
    _delegado?.removeListener(_aoRota);
    _delegado = delegado;
    _delegado!.addListener(_aoRota);
  }

  @override
  void dispose() {
    _delegado?.removeListener(_aoRota);
    _busca.dispose();
    super.dispose();
  }

  void _aoRota() {
    if (!mounted) return;
    if (GoRouter.of(context).state.uri.path != '/clientes') return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _carregar();
    });
  }

  Future<void> _abrirReuniao(String clienteId, {required bool executar}) async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null) return;
    final reunioes = await repo.listarReunioes(clienteId);
    final reuniao = reunioes.isEmpty
        ? await repo.guardarReuniao(
            clienteId: clienteId,
            perfil: null,
            expectativa: '',
            respostas: {},
            notasPlano: '',
            notasProposta: '',
            status: 'rascunho',
          )
        : reunioes.first;
    if (!mounted) return;
    final caminho = executar
        ? '/reuniao/${reuniao.id}'
        : '/reuniao/${reuniao.id}/etapas';
    await context.push(caminho);
    _carregar();
  }

  Future<void> _excluir(Cliente cliente) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Excluir cliente?'),
        content: Text(
          '${cliente.nome} e as reuniões deste cliente serão apagados.',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true || !mounted) return;
    final repo = Escopo.of(context).repositorio;
    final aviso = await repo?.excluirCliente(cliente.id);
    if (!mounted) return;
    if (aviso != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(aviso)));
    }
    _carregar();
  }

  Future<void> _carregar() async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null) return;
    final lista = await repo.listarClientes();
    if (!mounted) return;
    setState(() {
      _clientes = lista;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessao = Escopo.of(context);
    final termo = _busca.text.trim().toLowerCase();
    final visiveis = _clientes.where((c) {
      if (termo.isEmpty) return true;
      return c.nome.toLowerCase().contains(termo) ||
          c.email.toLowerCase().contains(termo);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: carvao,
                  backgroundColor: menta,
                  side: const BorderSide(color: menta),
                  shape: const StadiumBorder(),
                ),
                onPressed: () => context.push('/preferencias'),
                child: const Text('Preferências'),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Verificar atualizações',
            onPressed: () => verificarAtualizacao(context, manual: true),
            icon: const Icon(Icons.system_update_alt),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: sessao.auth.sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                children: [
                  if (sessao.avisoSync != null)
                    Container(
                      width: double.infinity,
                      color: aviso,
                      padding: const EdgeInsets.all(12),
                      child: Text(sessao.avisoSync!),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: TextField(
                      controller: _busca,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Buscar cliente',
                      ),
                    ),
                  ),
                  Expanded(
                    child: _carregando
                        ? const Center(child: CircularProgressIndicator())
                        : visiveis.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum cliente ainda. Cadastre o primeiro.',
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                            itemCount: visiveis.length + 1,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, indice) {
                              if (indice == 0)
                                return const _CabecalhoClientes();
                              final cliente = visiveis[indice - 1];
                              final contato = cliente.email.isEmpty
                                  ? cliente.telefone
                                  : cliente.email;
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () async {
                                            await context.push(
                                              '/clientes/${cliente.id}',
                                            );
                                            _carregar();
                                          },
                                          child: Text(
                                            cliente.nome,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          contato.isEmpty
                                              ? 'Sem contato'
                                              : contato,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          alignment: WrapAlignment.end,
                                          children: [
                                            FilledButton(
                                              onPressed: () => _abrirReuniao(
                                                cliente.id,
                                                executar: true,
                                              ),
                                              child: const Text('Executar'),
                                            ),
                                            OutlinedButton(
                                              onPressed: () => _abrirReuniao(
                                                cliente.id,
                                                executar: false,
                                              ),
                                              child: const Text(
                                                'Editar preparação',
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: () async {
                                                await context.push(
                                                  '/clientes/${cliente.id}/editar',
                                                );
                                                _carregar();
                                              },
                                              child: const Text(
                                                'Editar cliente',
                                              ),
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: erro,
                                                side: const BorderSide(
                                                  color: erro,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  _excluir(cliente),
                                              child: const Text('Excluir'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const IgnorePointer(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: _VersaoInstalada(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/clientes/novo');
          _carregar();
        },
        label: const Text('Cadastrar cliente'),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}

class _VersaoInstalada extends StatefulWidget {
  const _VersaoInstalada();

  @override
  State<_VersaoInstalada> createState() => _VersaoInstaladaState();
}

class _VersaoInstaladaState extends State<_VersaoInstalada> {
  String? _versao;

  @override
  void initState() {
    super.initState();
    _ler();
  }

  Future<void> _ler() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted || info.version.isEmpty) return;
      setState(() => _versao = info.version);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final versao = _versao;
    if (versao == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        'versão $versao',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bege),
      ),
    );
  }
}
