import 'package:flutter_test/flutter_test.dart';
import 'package:marco_zero/atualizacao/versao.dart';

void main() {
  test('só oferece versão estritamente maior', () {
    const corpo = '{"versao":"1.0.1","url":"https://exemplo/app.zip","notas":"Roteiro"}';
    final oferta = interpretarFeed(corpo, '1.0.0');
    expect(oferta?.versao, '1.0.1');
    expect(oferta?.url, 'https://exemplo/app.zip');
    expect(interpretarFeed(corpo, '1.0.1'), isNull);
    expect(interpretarFeed(corpo, '1.2.0'), isNull);
  });

  test('feed incompleto ou vazio não troca a instalação', () {
    expect(() => interpretarFeed('{}', '1.0.0'), throwsA(isA<FeedInvalido>()));
    expect(() => interpretarFeed('nao-json', '1.0.0'), throwsA(isA<FeedInvalido>()));
    expect(resolverUrlFeed(conteudoArquivo: null, compilada: ''), '');
    expect(
      resolverUrlFeed(conteudoArquivo: ' https://host/latest.json \n', compilada: 'outra'),
      'https://host/latest.json',
    );
  });
}
