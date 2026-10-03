import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/script/roteiro.dart';
import 'package:marco_zero/data/script/sugerir_perfil.dart';

void main() {
  test('cada sinal principal aponta um único perfil', () {
    expect(sugerirPerfil('quero quitar o cartão e reduzir os juros'), PerfilId.endividado);
    expect(sugerirPerfil('preciso organizar meu orçamento e controlar gastos'), PerfilId.organizacao);
    expect(sugerirPerfil('quero uma reserva de emergência e sair do banco'), PerfilId.investidor);
    expect(sugerirPerfil('vamos planejar a viagem e a reforma'), PerfilId.projetos);
    expect(sugerirPerfil('previdência para a aposentadoria'), PerfilId.aposentadoria);
  });

  test('texto vazio, sem sinal ou empate não escolhe sozinho', () {
    expect(sugerirPerfil(''), isNull);
    expect(sugerirPerfil('olá, tudo bem?'), isNull);
    expect(sugerirPerfil('viagem e aposentadoria'), isNull);
  });
}
