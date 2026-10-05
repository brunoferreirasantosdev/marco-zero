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
    },
  );

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
