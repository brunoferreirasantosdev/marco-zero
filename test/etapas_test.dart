import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/local/banco.dart';
import 'package:marco_zero/data/reuniao_repository.dart';
import 'package:marco_zero/data/script/etapas.dart';
import 'package:marco_zero/data/script/roteiro.dart';

void main() {
  test('texto vazio ou igual ao guia volta ao roteiro', () {
    final editadas = definirEtapa(
      {},
      'p1',
      '  pergunta nova  ',
      'pergunta do guia',
    );
    expect(textoEtapa(editadas, 'p1', 'pergunta do guia'), 'pergunta nova');
    final deVolta = definirEtapa(
      editadas,
      'p1',
      'pergunta do guia',
      'pergunta do guia',
    );
    expect(textoEtapa(deVolta, 'p1', 'pergunta do guia'), 'pergunta do guia');
    final vazio = definirEtapa(editadas, 'p1', '   ', 'pergunta do guia');
    expect(textoEtapa(vazio, 'p1', 'pergunta do guia'), 'pergunta do guia');
    expect(textoEtapa({}, 'p1', 'pergunta do guia'), 'pergunta do guia');
  });

  test('a edição fica só na reunião em que foi gravada', () async {
    final banco = AppDatabase.memoria();
    addTearDown(banco.close);
    final repo = Repositorio(banco: banco, uid: 'consultor');
    final ana = await repo.garantirCliente(
      nome: 'Ana',
      telefone: '',
      email: '',
    );
    final primeira = await repo.guardarReuniao(
      clienteId: ana.id,
      perfil: 'endividado',
      expectativa: 'quitar',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );
    final segunda = await repo.guardarReuniao(
      clienteId: ana.id,
      perfil: 'endividado',
      expectativa: 'quitar',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );

    await repo.salvarEtapas(primeira.id, {
      'endividado.acolhimento.01': 'Como está hoje, com calma?',
    });

    final recarregada = await repo.obterReuniao(primeira.id);
    final outra = await repo.obterReuniao(segunda.id);
    expect(
      textoEtapa(
        lerEtapas(recarregada!.etapasJson),
        'endividado.acolhimento.01',
        'texto do guia',
      ),
      'Como está hoje, com calma?',
    );
    expect(lerEtapas(outra!.etapasJson), isEmpty);
  });

  test('json antigo continua sendo texto e o novo guarda ordem e extra', () {
    final antigo = lerMontagem('{"pergunta.chave":"Oi"}');
    expect(antigo.textos['pergunta.chave'], 'Oi');
    expect(antigo.extras, isEmpty);

    final ida = Montagem(
      textos: {'pergunta.chave': 'Oi'},
      extras: [
        const ExtraBloco(
          id: 'extra.1',
          etapa: 'acolhimento',
          tipo: 'texto',
          texto: 'Nota',
        ),
      ],
      ordem: {
        'acolhimento': ['extra.1'],
      },
    );
    final volta = lerMontagem(gravarMontagem(ida));
    expect(volta.extras.single.texto, 'Nota');
    expect(volta.ordem['acolhimento'], ['extra.1']);
    expect(textoEtapa(volta.textos, 'pergunta.chave', 'guia'), 'Oi');
  });

  test('subir no topo leva o bloco para a etapa anterior', () {
    final ordem = {for (final etapa in etapasMontagem) etapa: <String>[]};
    ordem['expectativa'] = ['a'];
    ordem['acolhimento_perfil'] = ['b'];
    final nova = moverBloco(ordem, 'acolhimento_perfil', 0, -1);
    expect(nova['expectativa'], ['a', 'b']);
    expect(nova['acolhimento_perfil'], isEmpty);
    expect(ordem['acolhimento_perfil'], ['b']);
  });

  test(
    'campo novo fica na ordem salva e a pergunta do guia que faltava volta',
    () {
      final efetiva = ordemEfetiva(
        salva: {
          'acolhimento': ['extra.1', 'p1'],
        },
        padrao: {
          'acolhimento_perfil': ['ori', 'p1', 'campo.p1'],
        },
        extras: [
          const ExtraBloco(
            id: 'extra.1',
            etapa: 'acolhimento',
            tipo: 'campo',
            texto: 'Renda',
          ),
        ],
      );
      expect(efetiva['acolhimento_perfil'], [
        'extra.1',
        'p1',
        'ori',
        'campo.p1',
      ]);
    },
  );

  test('a preparação de uma reunião não altera a outra', () async {
    final banco = AppDatabase.memoria();
    addTearDown(banco.close);
    final repo = Repositorio(banco: banco, uid: 'consultor');
    final ana = await repo.garantirCliente(
      nome: 'Ana',
      telefone: '',
      email: '',
    );
    final primeira = await repo.guardarReuniao(
      clienteId: ana.id,
      perfil: 'endividado',
      expectativa: '',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );
    final segunda = await repo.guardarReuniao(
      clienteId: ana.id,
      perfil: 'endividado',
      expectativa: '',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );

    await repo.salvarMontagem(
      primeira.id,
      const Montagem(
        textos: {},
        extras: [
          ExtraBloco(
            id: 'extra.1',
            etapa: 'acolhimento',
            tipo: 'campo',
            texto: 'Renda',
          ),
        ],
        ordem: {
          'acolhimento': ['extra.1'],
        },
      ),
    );

    final recarregada = await repo.obterReuniao(primeira.id);
    final outra = await repo.obterReuniao(segunda.id);
    expect(lerMontagem(recarregada!.etapasJson).extras.single.texto, 'Renda');
    expect(lerMontagem(outra!.etapasJson).extras, isEmpty);
  });

  test('um modelo importado em outra reunião não muda a origem', () async {
    final banco = AppDatabase.memoria();
    addTearDown(banco.close);
    final repo = Repositorio(banco: banco, uid: 'consultor');
    final ana = await repo.garantirCliente(
      nome: 'Ana',
      telefone: '',
      email: '',
    );
    final bruno = await repo.garantirCliente(
      nome: 'Bruno',
      telefone: '',
      email: '',
    );
    final origem = await repo.guardarReuniao(
      clienteId: ana.id,
      perfil: 'endividado',
      expectativa: '',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );
    final destino = await repo.guardarReuniao(
      clienteId: bruno.id,
      perfil: null,
      expectativa: '',
      respostas: {},
      notasPlano: '',
      notasProposta: '',
      status: 'rascunho',
    );
    const montagem = Montagem(
      textos: {'pergunta.chave': 'O que você espera hoje?'},
      extras: [
        ExtraBloco(
          id: 'extra.1',
          etapa: 'acolhimento',
          tipo: 'texto',
          texto: 'Respire',
        ),
      ],
      ordem: {
        'acolhimento': ['extra.1'],
      },
    );
    final json = gravarMontagem(montagem);
    await repo.salvarMontagem(origem.id, montagem);
    await repo.salvarModelo(
      nome: 'Calmo',
      perfil: 'endividado',
      etapasJson: json,
    );
    final modelos = await repo.listarModelos();
    await repo.salvarMontagem(
      destino.id,
      lerMontagem(modelos.single.etapasJson),
    );

    final origemDepois = await repo.obterReuniao(origem.id);
    final destinoDepois = await repo.obterReuniao(destino.id);
    expect(
      lerMontagem(origemDepois!.etapasJson).extras.single.texto,
      'Respire',
    );
    expect(
      lerMontagem(destinoDepois!.etapasJson).textos['pergunta.chave'],
      'O que você espera hoje?',
    );
    expect(destinoDepois.clienteId, bruno.id);
    expect(origemDepois.clienteId, ana.id);
  });

  test('a cor da pergunta volta no json e o valor inválido sai', () {
    const montagem = Montagem(
      textos: {},
      extras: [],
      ordem: {},
      importancia: {'p1': importanciaAlta, 'p2': 'urgente'},
    );
    final volta = lerMontagem(gravarMontagem(montagem));
    expect(volta.importancia['p1'], importanciaAlta);
    expect(volta.importancia.containsKey('p2'), isFalse);
    expect(
      lerMontagem('{"v":2,"textos":{},"extras":[],"ordem":{}}').importancia,
      isEmpty,
    );
  });

  test('depois do alinhamento vem o perfil e os tópicos dele', () {
    expect(etapasRelogio.map((etapa) => etapa.chave).toList(), [
      'expectativa',
      'perfil',
      'acolhimento_perfil',
      'experiencia_perfil',
      'especificas_perfil',
      'conceitos',
      'proposta',
    ]);
    expect(etapasRelogio[5].nome, 'Conceito e plano');
    expect(
      etapasRelogio[3].nome,
      'Questões sobre a experiência/conhecimento do cliente no tema',
    );
    final semPerfil = padraoPorPerfil(null);
    expect(semPerfil['expectativa'], contains('padrao.expectativa.01'));
    expect(semPerfil.containsKey('acolhimento'), isFalse);
    expect(semPerfil['acolhimento_perfil'], isEmpty);
    final organizacao = padraoPorPerfil(perfilPorId(PerfilId.organizacao));
    expect(
      organizacao['acolhimento_perfil'],
      contains('organizacao.acolhimento.01'),
    );
    expect(
      organizacao['experiencia_perfil'],
      contains('organizacao.experiencia.01'),
    );
    expect(
      organizacao['especificas_perfil'],
      contains('organizacao.especificas.01'),
    );
    expect(
      textoPadraoBloco('padrao.expectativa.01', null),
      contains('motivou'),
    );
    expect(semPerfil['expectativa']!.last, chaveLigamentoExpectativa);
    expect(
      textoPadraoBloco(chaveLigamentoExpectativa, null),
      contains('[ Nome do cliente ]'),
    );
    expect(
      textoPadraoBloco(chaveLigamentoExpectativa, null),
      contains('porque'),
    );
    expect(
      textoPadraoBloco(chaveLigamentoExpectativa, null),
      isNot(contains('metodolia')),
    );
    final volta = lerMontagem(
      gravarMontagem(
        const Montagem(
          textos: {},
          extras: [],
          ordem: {},
          tempos: {'acolhimento_perfil': 12},
        ),
      ),
    );
    expect(volta.tempos['acolhimento_perfil'], 12);
  });

  test('o texto falado usa o nome cadastrado', () {
    expect(
      aplicarNomeCliente('juntos aqui, [ Nome do cliente ],', 'Marina'),
      'juntos aqui, Marina,',
    );
    expect(
      aplicarNomeCliente('juntos aqui, Jaqueline,', 'Marina'),
      'juntos aqui, Marina,',
    );
    expect(
      restaurarMarcadorNome('juntos aqui, Marina,', 'Marina'),
      'juntos aqui, [ Nome do cliente ],',
    );
  });
}
