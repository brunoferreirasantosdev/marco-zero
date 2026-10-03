import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/sync/mescla.dart';

void main() {
  test('fica com o updatedAt mais recente e completa os dois lados', () {
    final plano = planejarMescla(
      {'a': 2, 'b': 5, 'c': 1},
      {'a': 2, 'b': 4, 'd': 9},
    );
    expect(plano.puxar, ['d']);
    expect(plano.enviar, ['b', 'c']);
  });
}
