import 'dart:convert';

import 'etapas.dart';
import 'roteiro.dart';

const _inicioModelo = '<<<modelo>>>';
const _fimModelo = '<<</modelo>>>';

String nomeArquivoReuniao(String nomeCliente) {
  final limpo = nomeCliente.trim().replaceAll(RegExp(r'[<>:"/\\|?*]'), '').trim();
  final base = limpo.isEmpty ? 'cliente' : limpo;
  return 'Reunião $base.txt';
}

String textoDaReuniao({
  required String nomeCliente,
  required PerfilId? perfilId,
  required Montagem montagem,
  required Map<String, String> respostas,
}) {
  final perfil = perfilId == null ? null : perfilPorId(perfilId);
  final ordem = ordemEfetiva(
    salva: montagem.ordem,
    padrao: padraoPorPerfil(perfil),
    extras: montagem.extras,
  );
  final extras = {for (final extra in montagem.extras) extra.id: extra};
  final nome = nomeCliente.trim().isEmpty ? 'Nome do cliente' : nomeCliente.trim();
  final buffer = StringBuffer()
    ..writeln('Reunião Marco Zero')
    ..writeln('Cliente: $nome')
    ..writeln('Perfil: ${perfil?.titulo ?? 'Ainda não confirmado'}')
    ..writeln();

  for (final etapa in etapasRelogio) {
    buffer.writeln(etapa.nome);
    if (etapa.chave == 'perfil') {
      buffer.writeln(perfil?.titulo ?? 'Ainda não confirmado');
      buffer.writeln();
      continue;
    }
    for (final id in ordem[etapa.chave] ?? const <String>[]) {
      _bloco(
        buffer,
        id: id,
        perfil: perfil,
        montagem: montagem,
        extras: extras,
        respostas: respostas,
        nome: nome,
      );
    }
    buffer.writeln();
  }
  final legivel = buffer.toString().trimRight();
  final pacote = jsonEncode({
    'perfil': perfilId?.name,
    'montagem': jsonDecode(gravarMontagem(montagem)),
  });
  return '$legivel\n\n$_inicioModelo\n$pacote\n$_fimModelo';
}

class ReuniaoExportada {
  const ReuniaoExportada({required this.perfil, required this.montagem});

  final PerfilRoteiro? perfil;
  final Montagem montagem;
}

bool nomeDeExportacao(String nome) {
  return nome.startsWith('Reunião ') && nome.toLowerCase().endsWith('.txt');
}

ReuniaoExportada? lerReuniaoExportada(String texto) {
  final normalizado = texto.replaceAll('\r\n', '\n');
  final peloPacote = _lerPacote(normalizado);
  if (peloPacote != null) return peloPacote;
  return _lerProsa(normalizado.split(_inicioModelo).first);
}

void _bloco(
  StringBuffer buffer, {
  required String id,
  required PerfilRoteiro? perfil,
  required Montagem montagem,
  required Map<String, ExtraBloco> extras,
  required Map<String, String> respostas,
  required String nome,
}) {
  final extra = extras[id];
  if (extra != null) {
    buffer.writeln(textoEtapa(montagem.textos, id, extra.texto));
    if (extra.tipo == 'campo') _resposta(buffer, respostas[id]);
    buffer.writeln();
    return;
  }
  if (id == chaveCampoExpectativa) {
    _resposta(buffer, respostas[id]);
    return;
  }
  if (id == chaveCampoConceitos || id == chaveCampoProposta) {
    buffer.writeln(id == chaveCampoConceitos ? 'Plano' : 'Proposta');
    final nota = (respostas[id] ?? '').trim();
    buffer.writeln(nota.isEmpty ? 'Sem anotação.' : nota);
    buffer.writeln();
    return;
  }
  if (id.startsWith(prefixoCampo)) {
    _resposta(buffer, respostas[id.substring(prefixoCampo.length)]);
    return;
  }
  final padrao = textoPadraoBloco(id, perfil);
  if (padrao == null) return;
  final bruto = textoEtapa(montagem.textos, id, padrao);
  final texto = aplicarNomeCliente(bruto, nome);
  buffer.writeln(texto);
  buffer.writeln();
}

void _resposta(StringBuffer buffer, String? valor) {
  final texto = (valor ?? '').trim();
  if (texto.isEmpty) return;
  buffer.writeln(texto);
  buffer.writeln();
}

ReuniaoExportada? _lerPacote(String texto) {
  final inicio = texto.indexOf(_inicioModelo);
  final fim = texto.indexOf(_fimModelo);
  if (inicio < 0 || fim <= inicio) return null;
  final miolo = texto.substring(inicio + _inicioModelo.length, fim).trim();
  try {
    final data = jsonDecode(miolo);
    if (data is! Map) return null;
    final montagemBruta = data['montagem'];
    return ReuniaoExportada(
      perfil: perfilPorNome(data['perfil']?.toString()),
      montagem: montagemBruta is Map
          ? lerMontagem(jsonEncode(montagemBruta))
          : Montagem.vazia(),
    );
  } on FormatException {
    return null;
  }
}

ReuniaoExportada? _lerProsa(String texto) {
  if (!texto.contains('Reunião Marco Zero')) return null;
  final secoes = <String, String>{};
  final buffer = StringBuffer();
  String? atual;
  String cliente = '';
  String? tituloPerfil;

  void guardar() {
    if (atual != null) secoes.putIfAbsent(atual!, () => buffer.toString().trim());
    buffer.clear();
  }

  for (final linha in texto.split('\n')) {
    final etapa = etapasRelogio.where((item) => item.nome == linha).firstOrNull;
    if (etapa != null) {
      guardar();
      atual = secoes.containsKey(etapa.chave) ? null : etapa.chave;
      continue;
    }
    if (atual == null) {
      if (linha.startsWith('Cliente: ')) cliente = linha.substring('Cliente: '.length).trim();
      if (linha.startsWith('Perfil: ')) {
        tituloPerfil = linha.substring('Perfil: '.length).trim();
      }
      continue;
    }
    buffer.writeln(linha);
  }
  guardar();

  final perfil = _perfilPeloTitulo(tituloPerfil);
  return ReuniaoExportada(
    perfil: perfil,
    montagem: _montagemDaProsa(perfil: perfil, cliente: cliente, secoes: secoes),
  );
}

PerfilRoteiro? _perfilPeloTitulo(String? titulo) {
  if (titulo == null || titulo.isEmpty || titulo == 'Ainda não confirmado') {
    return null;
  }
  for (final perfil in roteiro) {
    if (perfil.titulo == titulo) return perfil;
  }
  return null;
}

Montagem _montagemDaProsa({
  required PerfilRoteiro? perfil,
  required String cliente,
  required Map<String, String> secoes,
}) {
  final padrao = padraoPorPerfil(perfil);
  var textos = <String, String>{};
  for (final etapa in etapasMontagem) {
    final corpo = secoes[etapa];
    if (corpo == null || corpo.isEmpty) continue;
    final ids = padrao[etapa] ?? const <String>[];
    if (etapa == 'conceitos' || etapa == 'proposta') {
      final id = etapa == 'conceitos' ? chavePlanoConceitos : chaveTextoProposta;
      final rotulo = etapa == 'conceitos' ? 'Plano' : 'Proposta';
      final padraoTexto = textoPadraoBloco(id, perfil);
      if (padraoTexto == null) continue;
      textos = definirEtapa(
        textos,
        id,
        restaurarMarcadorNome(_antesDoRotulo(corpo, rotulo), cliente),
        padraoTexto,
      );
      continue;
    }
    final paragrafos = _paragrafos(corpo);
    var indice = 0;
    for (var posicao = 0; posicao < ids.length; posicao++) {
      final id = ids[posicao];
      if (id.startsWith(prefixoCampo)) {
        final seguinte = _proximoPadrao(ids, posicao, perfil, cliente);
        if (indice < paragrafos.length && paragrafos[indice] != seguinte) {
          indice++;
        }
        continue;
      }
      final padraoTexto = textoPadraoBloco(id, perfil);
      if (padraoTexto == null || indice >= paragrafos.length) continue;
      textos = definirEtapa(
        textos,
        id,
        restaurarMarcadorNome(paragrafos[indice], cliente),
        padraoTexto,
      );
      indice++;
    }
  }
  return Montagem(textos: textos, extras: const [], ordem: const {});
}

String _antesDoRotulo(String corpo, String rotulo) {
  final linhas = corpo.split('\n');
  final corte = linhas.indexWhere((linha) => linha.trim() == rotulo);
  final trecho = corte == -1 ? linhas : linhas.sublist(0, corte);
  return trecho.join('\n').trim();
}

List<String> _paragrafos(String corpo) {
  return corpo
      .split(RegExp(r'\n\s*\n'))
      .map((paragrafo) => paragrafo.trim())
      .where(
        (paragrafo) =>
            paragrafo.isNotEmpty &&
            paragrafo != 'Sem anotação.' &&
            paragrafo != 'Plano' &&
            paragrafo != 'Proposta',
      )
      .toList();
}

String? _proximoPadrao(
  List<String> ids,
  int posicao,
  PerfilRoteiro? perfil,
  String cliente,
) {
  for (var indice = posicao + 1; indice < ids.length; indice++) {
    final padrao = textoPadraoBloco(ids[indice], perfil);
    if (padrao != null) return aplicarNomeCliente(padrao, cliente);
  }
  return null;
}
