import 'package:cloud_firestore/cloud_firestore.dart';

import '../local/banco.dart';
import '../respostas.dart';
import '../script/etapas.dart';
import 'sync_remoto.dart';

class FirestoreSync implements SyncRemoto {
  FirestoreSync(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _clientes(String uid) {
    return _firestore.collection('users').doc(uid).collection('clients');
  }

  @override
  Future<List<Cliente>> puxarClientes(String uid) async {
    final snap = await _clientes(uid).get();
    return [
      for (final doc in snap.docs) _cliente(uid, doc.id, doc.data()),
    ];
  }

  @override
  Future<List<Reuniao>> puxarReunioes(String uid, String clienteId) async {
    final snap = await _clientes(uid).doc(clienteId).collection('meetings').get();
    return [
      for (final doc in snap.docs) _reuniao(uid, clienteId, doc.id, doc.data()),
    ];
  }

  @override
  Future<void> enviarCliente(Cliente cliente) {
    return _clientes(cliente.ownerUid).doc(cliente.id).set({
      'nome': cliente.nome,
      'telefone': cliente.telefone,
      'email': cliente.email,
      'updatedAt': cliente.updatedAt,
    });
  }

  @override
  Future<void> apagarCliente(String uid, String clienteId) async {
    final encontros = await _clientes(uid).doc(clienteId).collection('meetings').get();
    for (final doc in encontros.docs) {
      await doc.reference.delete();
    }
    await _clientes(uid).doc(clienteId).delete();
  }

  @override
  Future<void> enviarReuniao(Reuniao reuniao) {
    return _clientes(reuniao.ownerUid)
        .doc(reuniao.clienteId)
        .collection('meetings')
        .doc(reuniao.id)
        .set({
          'perfil': reuniao.perfil,
          'expectativa': reuniao.expectativa,
          'respostas': lerRespostas(reuniao.respostasJson),
          'notasPlano': reuniao.notasPlano,
          'notasProposta': reuniao.notasProposta,
          'status': reuniao.status,
          'etapas': etapasParaNuvem(reuniao.etapasJson),
          'updatedAt': reuniao.updatedAt,
        });
  }

  Cliente _cliente(String uid, String id, Map<String, dynamic> dados) {
    return Cliente(
      id: id,
      ownerUid: uid,
      nome: dados['nome'] as String? ?? '',
      telefone: dados['telefone'] as String? ?? '',
      email: dados['email'] as String? ?? '',
      updatedAt: (dados['updatedAt'] as num?)?.toInt() ?? 0,
    );
  }

  Reuniao _reuniao(
    String uid,
    String clienteId,
    String id,
    Map<String, dynamic> dados,
  ) {
    final respostas = dados['respostas'];
    final mapa = respostas is Map
        ? respostas.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
        : <String, String>{};
    final etapasJson = etapasDaNuvem(dados['etapas']);
    return Reuniao(
      id: id,
      clienteId: clienteId,
      ownerUid: uid,
      perfil: dados['perfil'] as String?,
      expectativa: dados['expectativa'] as String? ?? '',
      respostasJson: gravarRespostas(mapa),
      notasPlano: dados['notasPlano'] as String? ?? '',
      notasProposta: dados['notasProposta'] as String? ?? '',
      status: dados['status'] as String? ?? 'rascunho',
      etapasJson: etapasJson,
      updatedAt: (dados['updatedAt'] as num?)?.toInt() ?? 0,
    );
  }
}
