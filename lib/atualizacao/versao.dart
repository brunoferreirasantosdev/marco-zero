import 'dart:convert';

class OfertaAtualizacao {
  const OfertaAtualizacao({
    required this.versao,
    required this.url,
    required this.notas,
  });

  final String versao;
  final String url;
  final String notas;
}

class FeedInvalido implements Exception {
  const FeedInvalido();
}

String resolverUrlFeed({String? conteudoArquivo, required String compilada}) {
  final arquivo = conteudoArquivo?.trim();
  if (arquivo != null && arquivo.isNotEmpty) {
    return arquivo.split(RegExp(r'\r?\n')).first.trim();
  }
  return compilada.trim();
}

bool versaoMaior(String remota, String local) {
  final a = _partes(remota);
  final b = _partes(local);
  if (a == null || b == null) return false;
  final tamanho = a.length > b.length ? a.length : b.length;
  for (var i = 0; i < tamanho; i++) {
    final x = i < a.length ? a[i] : 0;
    final y = i < b.length ? b[i] : 0;
    if (x > y) return true;
    if (x < y) return false;
  }
  return false;
}

List<int>? _partes(String versao) {
  final nucleo = versao.split('+').first.split('-').first.trim();
  if (nucleo.isEmpty) return null;
  final numeros = <int>[];
  for (final pedaco in nucleo.split('.')) {
    final numero = int.tryParse(pedaco);
    if (numero == null) return null;
    numeros.add(numero);
  }
  return numeros;
}

/// Devolve a oferta quando o feed anuncia versão estritamente maior.
OfertaAtualizacao? interpretarFeed(String corpo, String versaoAtual) {
  final dynamic data;
  try {
    data = jsonDecode(corpo);
  } on FormatException {
    throw const FeedInvalido();
  }
  if (data is! Map) throw const FeedInvalido();
  final versao = data['versao'];
  final url = data['url'];
  if (versao is! String || url is! String || versao.isEmpty || url.isEmpty) {
    throw const FeedInvalido();
  }
  final notas = data['notas'];
  if (!versaoMaior(versao, versaoAtual)) return null;
  return OfertaAtualizacao(
    versao: versao,
    url: url,
    notas: notas is String ? notas : '',
  );
}
