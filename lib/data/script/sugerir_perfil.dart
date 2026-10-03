import 'roteiro.dart';

String normalizar(String texto) {
  const origem = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  const destino = 'aaaaaeeeeiiiiooooouuuucn';
  final buffer = StringBuffer();
  for (final rune in texto.toLowerCase().runes) {
    final caractere = String.fromCharCode(rune);
    final indice = origem.indexOf(caractere);
    buffer.write(indice >= 0 ? destino[indice] : caractere);
  }
  return buffer.toString();
}

/// Devolve um perfil só quando um único tema pontua mais que os outros.
PerfilId? sugerirPerfil(String expectativa) {
  final texto = normalizar(expectativa);
  if (texto.trim().isEmpty) return null;

  final pontos = <PerfilId, int>{};
  for (final perfil in roteiro) {
    var soma = 0;
    for (final palavra in perfil.palavras) {
      if (texto.contains(palavra)) soma++;
    }
    pontos[perfil.id] = soma;
  }

  final maior = pontos.values.fold<int>(0, (a, b) => a > b ? a : b);
  if (maior == 0) return null;
  final vencedores = pontos.entries.where((e) => e.value == maior).toList();
  if (vencedores.length != 1) return null;
  return vencedores.single.key;
}
