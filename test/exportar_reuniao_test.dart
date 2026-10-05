import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/script/etapas.dart';
import 'package:marco_zero/data/script/exportar_reuniao.dart';
import 'package:marco_zero/data/script/roteiro.dart';

void main() {
  test(
    'a exportação traz o cliente, a resposta e o nome no texto de ligação',
    () {
      final texto = textoDaReuniao(
        nomeCliente: 'Jaqueline',
        perfilId: PerfilId.organizacao,
        montagem: Montagem.vazia(),
        respostas: {chaveCampoExpectativa: 'Quero organizar'},
      );

      expect(texto, contains('Cliente: Jaqueline'));
      expect(texto, contains('Organização orçamentária'));
      expect(texto, contains('Quero organizar'));
      expect(texto, contains('juntos aqui, Jaqueline,'));
      expect(texto, contains('organizar o orçamento'));
      expect(texto, contains('R\$ 300 por mês'));
      expect(texto, contains('6 meses'));
      expect(texto, contains('12 meses'));
      expect(texto, isNot(contains('999')));
      expect(texto, isNot(contains('[ Nome do cliente ]')));
      expect(nomeArquivoReuniao('Jaqueline'), 'Reunião Jaqueline.txt');
      expect(nomeArquivoModelo('Organização'), 'Modelo Organização.txt');
      expect(nomeDeExportacao('Modelo Organização.txt'), isTrue);
      final lida = lerReuniaoExportada(texto);
      expect(lida?.perfil?.id, PerfilId.organizacao);
      expect(lida?.montagem.textos, isEmpty);
    },
  );

  test('o txt exportado antigo, sem o pacote, vira modelo do perfil', () {
    final texto = textoDaReuniao(
      nomeCliente: 'João',
      perfilId: PerfilId.organizacao,
      montagem: Montagem(
        textos: {
          'organizacao.acolhimento.01': 'Pergunta ajustada para este modelo',
        },
        extras: const [],
        ordem: const {},
      ),
      respostas: {chaveCampoExpectativa: 'Quero organizar'},
    ).split('<<<modelo>>>').first;

    final lida = lerReuniaoExportada(texto);

    expect(lida?.perfil?.titulo, 'Organização orçamentária');
    expect(
      lida?.montagem.textos['organizacao.acolhimento.01'],
      'Pergunta ajustada para este modelo',
    );
    expect(lida?.montagem.textos.containsKey(chaveLigamentoExpectativa), isFalse);
    expect(nomeDeExportacao('Reunião João.txt'), isTrue);
    expect(nomeDeExportacao('notas.txt'), isFalse);
  });

  test('cada perfil tem o próprio plano e a proposta fica em 300', () {
    expect(planoDeAcao(PerfilId.endividado), contains('seis a doze'));
    expect(
      planoDeAcao(PerfilId.investidor),
      contains('estratégia de investimento'),
    );
    expect(planoDeAcao(PerfilId.projetos), contains('seu projeto'));
    expect(
      planoDeAcao(PerfilId.aposentadoria),
      contains('independência financeira'),
    );
    final proposta = propostaComercial(PerfilId.endividado);
    expect(proposta, contains('seis a doze'));
    expect(proposta, contains('R\$ 300 por mês'));
    expect(proposta, isNot(contains('299')));
  });
}
