import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/local/banco.dart';
import 'package:marco_zero/data/script/roteiro.dart';
import 'package:marco_zero/data/respostas.dart';
import 'package:marco_zero/data/reuniao_repository.dart';
import 'package:marco_zero/data/sync/sync_remoto.dart';
import 'package:marco_zero/ui/reuniao_regras.dart';

void main() {
  test('não avança sem expectativa e perfil', () {
    expect(
      motivoParadaInicial(expectativa: '  ', perfil: null),
      'Registre a expectativa do encontro.',
    );
    expect(
      motivoParadaInicial(expectativa: 'quitar dívidas', perfil: null),
      'Confirme o perfil antes de seguir.',
    );
    expect(
      motivoParadaInicial(expectativa: 'quitar dívidas', perfil: PerfilId.endividado),
      isNull,
    );
  });

  test('o relógio formata o decorrido e marca só o que passa da referência', () {
    expect(formatarDuracao(Duration.zero), '00:00');
    expect(formatarDuracao(const Duration(seconds: 65)), '01:05');
    expect(formatarDuracao(const Duration(seconds: 3661)), '1:01:01');
    expect(tempoAcimaDaMeta(const Duration(minutes: 3), 3), isFalse);
    expect(tempoAcimaDaMeta(const Duration(minutes: 3, seconds: 1), 3), isTrue);
  });

  test('respostas de cada cliente ficam separadas e fora da outra conta', () async {
    final banco = AppDatabase.memoria();
    addTearDown(banco.close);
    final repo = Repositorio(banco: banco, uid: 'consultor-1');
    final ana = await repo.garantirCliente(nome: 'Ana', telefone: '', email: '');
    final bruno = await repo.garantirCliente(nome: 'Bruno', telefone: '', email: '');
    await repo.guardarReuniao(
      clienteId: ana.id,
      perfil: 'organizacao',
      expectativa: 'orçamento',
      respostas: {'organizacao.acolhimento.01': 'apertado'},
      notasPlano: 'caixinhas',
      notasProposta: 'plano anual',
      status: 'rascunho',
    );
    await repo.guardarReuniao(
      clienteId: bruno.id,
      perfil: 'endividado',
      expectativa: 'quitar',
      respostas: {'endividado.acolhimento.01': 'cartão'},
      notasPlano: '',
      notasProposta: '',
      status: 'concluida',
    );

    final daAna = await repo.listarReunioes(ana.id);
    final doBruno = await repo.listarReunioes(bruno.id);
    expect(lerRespostas(daAna.single.respostasJson)['organizacao.acolhimento.01'], 'apertado');
    expect(lerRespostas(doBruno.single.respostasJson).containsKey('organizacao.acolhimento.01'), isFalse);
    expect(daAna.single.notasPlano, 'caixinhas');

    final outraConta = Repositorio(banco: banco, uid: 'consultor-2');
    expect(await outraConta.listarClientes(), isEmpty);
  });

  test('excluir cliente apaga as reuniões dele e mantém o outro', () async {
    final banco = AppDatabase.memoria();
    addTearDown(banco.close);
    final repo = Repositorio(banco: banco, uid: 'consultor');
    final ana = await repo.garantirCliente(nome: 'Ana', telefone: '', email: '');
    final bruno = await repo.garantirCliente(nome: 'Bruno', telefone: '', email: '');
    await repo.guardarReuniao(
      clienteId: ana.id,
      perfil: null,
      expectativa: '',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );

    await repo.excluirCliente(ana.id);

    expect(await repo.obterCliente(ana.id), isNull);
    expect(await repo.listarReunioes(ana.id), isEmpty);
    expect((await repo.obterCliente(bruno.id))?.nome, 'Bruno');
  });

  test('cliente excluído não volta enquanto a nuvem ainda o tem', () async {
    final banco = AppDatabase.memoria();
    addTearDown(banco.close);
    final nuvem = _NuvemQueFalha();
    final repo = Repositorio(banco: banco, uid: 'consultor', remoto: nuvem);
    final ana = await repo.garantirCliente(nome: 'Ana', telefone: '', email: '');
    nuvem.clientes.add(ana);

    final aviso = await repo.excluirCliente(ana.id);
    expect(aviso, isNotNull);
    await repo.sincronizar();

    expect(await repo.obterCliente(ana.id), isNull);
  });
}

class _NuvemQueFalha implements SyncRemoto {
  final clientes = <Cliente>[];

  @override
  Future<void> apagarCliente(String uid, String clienteId) async {
    throw Exception('sem rede');
  }

  @override
  Future<void> enviarCliente(Cliente cliente) async {}

  @override
  Future<void> enviarReuniao(Reuniao reuniao) async {}

  @override
  Future<List<Cliente>> puxarClientes(String uid) async => clientes;

  @override
  Future<List<Reuniao>> puxarReunioes(String uid, String clienteId) async => const [];
}
