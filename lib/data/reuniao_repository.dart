import 'package:drift/drift.dart';

import 'ids.dart';
import 'local/banco.dart';
import 'respostas.dart';
import 'preferencias.dart';
import 'script/etapas.dart';
import 'sync/mescla.dart';
import 'sync/sync_remoto.dart';

const avisoNuvem =
    'Salvo neste computador. A sincronização com a nuvem não ocorreu.';

class Repositorio {
  Repositorio({required this.banco, required this.uid, this.remoto});

  final AppDatabase banco;
  final String uid;
  final SyncRemoto? remoto;

  Future<List<Cliente>> listarClientes() {
    return (banco.select(banco.clientes)
          ..where((c) => c.ownerUid.equals(uid))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  Future<Cliente?> obterCliente(String id) {
    return (banco.select(banco.clientes)
          ..where((c) => c.id.equals(id) & c.ownerUid.equals(uid)))
        .getSingleOrNull();
  }

  Future<List<Reuniao>> listarReunioes(String clienteId) {
    return (banco.select(banco.reunioes)
          ..where((r) => r.clienteId.equals(clienteId) & r.ownerUid.equals(uid))
          ..orderBy([(r) => OrderingTerm.desc(r.updatedAt)]))
        .get();
  }

  Future<Reuniao?> obterReuniao(String id) {
    return (banco.select(banco.reunioes)
          ..where((r) => r.id.equals(id) & r.ownerUid.equals(uid)))
        .getSingleOrNull();
  }

  Future<String?> salvarCliente(Cliente cliente) async {
    await banco.into(banco.clientes).insertOnConflictUpdate(cliente);
    return _enviar(() => remoto!.enviarCliente(cliente));
  }

  Future<String?> salvarReuniao(Reuniao reuniao) async {
    await banco.into(banco.reunioes).insertOnConflictUpdate(reuniao);
    return _enviar(() => remoto!.enviarReuniao(reuniao));
  }

  Future<Cliente> garantirCliente({
    String? id,
    required String nome,
    required String telefone,
    required String email,
  }) async {
    final agora = DateTime.now().millisecondsSinceEpoch;
    final cliente = Cliente(
      id: id ?? novoId(),
      ownerUid: uid,
      nome: nome.trim(),
      telefone: telefone.trim(),
      email: email.trim(),
      updatedAt: agora,
    );
    await salvarCliente(cliente);
    return cliente;
  }

  Future<Reuniao> guardarReuniao({
    String? id,
    required String clienteId,
    required String? perfil,
    required String expectativa,
    required Map<String, String> respostas,
    required String notasPlano,
    required String notasProposta,
    required String status,
    String etapasJson = '{}',
  }) async {
    final reuniao = Reuniao(
      id: id ?? novoId(),
      clienteId: clienteId,
      ownerUid: uid,
      perfil: perfil,
      expectativa: expectativa,
      respostasJson: gravarRespostas(respostas),
      notasPlano: notasPlano,
      notasProposta: notasProposta,
      status: status,
      etapasJson: etapasJson,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await salvarReuniao(reuniao);
    return reuniao;
  }

  Future<String?> salvarEtapas(String reuniaoId, Map<String, String> etapas) async {
    final atual = await obterReuniao(reuniaoId);
    if (atual == null) return 'Reunião não encontrada.';
    final nova = atual.copyWith(
      etapasJson: gravarEtapas(etapas),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    return salvarReuniao(nova);
  }

  Future<List<Modelo>> listarModelos() {
    return (banco.select(banco.modelos)
          ..where((m) => m.ownerUid.equals(uid))
          ..orderBy([(m) => OrderingTerm.desc(m.updatedAt)]))
        .get();
  }

  Future<Modelo> salvarModelo({
    String? id,
    required String nome,
    required String? perfil,
    required String etapasJson,
  }) async {
    final modelo = Modelo(
      id: id ?? novoId(),
      ownerUid: uid,
      nome: nome.trim(),
      perfil: perfil,
      etapasJson: etapasJson,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await banco.into(banco.modelos).insertOnConflictUpdate(modelo);
    return modelo;
  }

  Future<String?> salvarMontagem(String reuniaoId, Montagem montagem) async {
    final atual = await obterReuniao(reuniaoId);
    if (atual == null) return 'Reunião não encontrada.';
    final nova = atual.copyWith(
      etapasJson: gravarMontagem(montagem),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    return salvarReuniao(nova);
  }

  Future<Preferencias> obterPreferencias() async {
    final linha = await (banco.select(banco.ajustes)..where((a) => a.ownerUid.equals(uid))).getSingleOrNull();
    if (linha == null) return Preferencias.padrao;
    return lerPreferencias(linha.json);
  }

  Future<void> salvarPreferencias(Preferencias prefs) {
    return banco.into(banco.ajustes).insertOnConflictUpdate(
      Ajuste(ownerUid: uid, json: gravarPreferencias(prefs)),
    );
  }

  Future<String?> excluirCliente(String id) async {
    final agora = DateTime.now().millisecondsSinceEpoch;
    await banco.into(banco.exclusoes).insertOnConflictUpdate(
      Exclusao(id: id, ownerUid: uid, updatedAt: agora),
    );
    await (banco.delete(banco.reunioes)..where((r) => r.clienteId.equals(id) & r.ownerUid.equals(uid))).go();
    await (banco.delete(banco.clientes)..where((c) => c.id.equals(id) & c.ownerUid.equals(uid))).go();
    if (remoto == null) return null;
    final falha = await _enviar(() => remoto!.apagarCliente(uid, id));
    if (falha == null) {
      await (banco.delete(banco.exclusoes)..where((e) => e.id.equals(id) & e.ownerUid.equals(uid))).go();
    }
    return falha;
  }

  Future<List<Exclusao>> _exclusoes() {
    return (banco.select(banco.exclusoes)..where((e) => e.ownerUid.equals(uid))).get();
  }

  Future<String?> sincronizar() async {
    if (remoto == null) return null;
    try {
      final pendentes = await _exclusoes();
      for (final item in pendentes) {
        try {
          await remoto!.apagarCliente(uid, item.id);
          await (banco.delete(banco.exclusoes)..where((e) => e.id.equals(item.id) & e.ownerUid.equals(uid))).go();
        } catch (_) {}
      }
      final bloqueados = {for (final item in await _exclusoes()) item.id};
      final locais = await listarClientes();
      final remotos = await remoto!.puxarClientes(uid);
      final plano = planejarMescla(
        {for (final c in locais) c.id: c.updatedAt},
        {for (final c in remotos) c.id: c.updatedAt},
      );
      final remotoPorId = {for (final c in remotos) c.id: c};
      final localPorId = {for (final c in locais) c.id: c};
      for (final id in plano.puxar) {
        if (bloqueados.contains(id)) continue;
        final cliente = remotoPorId[id];
        if (cliente != null) {
          await banco.into(banco.clientes).insertOnConflictUpdate(cliente);
        }
      }
      for (final id in plano.enviar) {
        final cliente = localPorId[id];
        if (cliente != null) await remoto!.enviarCliente(cliente);
      }

      final ids = {...localPorId.keys, ...remotoPorId.keys};
      for (final clienteId in ids) {
        if (bloqueados.contains(clienteId)) continue;
        await _sincronizarReunioes(clienteId);
      }
      return null;
    } catch (_) {
      return avisoNuvem;
    }
  }

  Future<void> _sincronizarReunioes(String clienteId) async {
    final locais = await listarReunioes(clienteId);
    final remotos = await remoto!.puxarReunioes(uid, clienteId);
    final plano = planejarMescla(
      {for (final r in locais) r.id: r.updatedAt},
      {for (final r in remotos) r.id: r.updatedAt},
    );
    final remotoPorId = {for (final r in remotos) r.id: r};
    final localPorId = {for (final r in locais) r.id: r};
    for (final id in plano.puxar) {
      final reuniao = remotoPorId[id];
      if (reuniao != null) {
        await banco.into(banco.reunioes).insertOnConflictUpdate(reuniao);
      }
    }
    for (final id in plano.enviar) {
      final reuniao = localPorId[id];
      if (reuniao != null) await remoto!.enviarReuniao(reuniao);
    }
  }

  Future<String?> _enviar(Future<void> Function() acao) async {
    if (remoto == null) return null;
    try {
      await acao();
      return null;
    } catch (_) {
      return avisoNuvem;
    }
  }
}
