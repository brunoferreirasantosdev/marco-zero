import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/script/roteiro.dart';

void main() {
  test('a pergunta-chave do guia está no roteiro', () {
    expect(perguntaChave, contains('expectativa'));
  });
}
