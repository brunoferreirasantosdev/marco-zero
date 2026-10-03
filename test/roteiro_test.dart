import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/script/roteiro.dart';

void main() {
  test('os cinco perfis do guia têm perguntas nas três etapas', () {
    expect(roteiro, hasLength(5));
    final ids = <String>{};
    for (final perfil in roteiro) {
      expect(perfil.sinais, isNotEmpty);
      for (final etapa in EtapaPerguntas.values) {
        final perguntas = perfil.daEtapa(etapa);
        expect(perguntas, isNotEmpty);
        for (final pergunta in perguntas) {
          expect(ids.add(pergunta.id), isTrue, reason: pergunta.id);
          expect(pergunta.texto, isNotEmpty);
        }
      }
    }
  });
}
