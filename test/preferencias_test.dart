import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/data/local/banco.dart';
import 'package:marco_zero/data/preferencias.dart';
import 'package:marco_zero/data/reuniao_repository.dart';

void main() {
  test('sem ajuste salvo vale o tempo e a cor padrão', () {
    final prefs = lerPreferencias('{}');
    expect(prefs.minutosDe('acolhimento_perfil'), 7);
    expect(prefs.corAlta, Preferencias.corAltaPadrao);
    expect(Preferencias.minutosEfetivos(daReuniao: null, daPreferencia: 9), 9);
    expect(Preferencias.minutosEfetivos(daReuniao: 4, daPreferencia: 9), 4);
  });

  test('a preferência fica na conta e não muda a outra', () async {
    final banco = AppDatabase.memoria();
    addTearDown(banco.close);
    final um = Repositorio(banco: banco, uid: 'um');
    final outro = Repositorio(banco: banco, uid: 'outro');
    final salva = Preferencias(
      minutos: {...Preferencias.padrao.minutos, 'expectativa': 8},
      corAlta: 0xFF1F6FEB,
      corMedia: Preferencias.corMediaPadrao,
      corBaixa: Preferencias.corBaixaPadrao,
    );
    await um.salvarPreferencias(salva);

    final lida = await um.obterPreferencias();
    expect(lida.minutosDe('expectativa'), 8);
    expect(lida.corAlta, 0xFF1F6FEB);
    expect((await outro.obterPreferencias()).minutosDe('expectativa'), 3);
  });
}
