import 'dart:convert';

import 'roteiro.dart';

const chavePerguntaExpectativa = 'pergunta.chave';
const chaveLigamentoExpectativa = 'ligamento.expectativa';
const chavePlanoConceitos = 'plano.conceitos';
const chaveTextoProposta = 'proposta.texto';

bool textoDeFala(String id) =>
    id.startsWith('ligamento.') || id == chavePlanoConceitos || id == chaveTextoProposta;

String aplicarNomeCliente(String texto, String nome) {
  final pessoa = nome.trim().isEmpty ? 'Nome do cliente' : nome.trim();
  return texto.replaceAll('[ Nome do cliente ]', pessoa);
}

const chaveOrientacaoExpectativa = 'orientacao.expectativa';
const chaveCampoExpectativa = 'campo.expectativa';
const chaveCampoConceitos = 'campo.conceitos';
const chaveCampoProposta = 'campo.proposta';
const prefixoCampo = 'campo.';
const importanciaAlta = 'alta';
const importanciaMedia = 'media';
const importanciaBaixa = 'baixa';

const etapasMontagem = [
  'expectativa',
  'acolhimento',
  'experiencia',
  'especificas',
  'acolhimento_perfil',
  'experiencia_perfil',
  'especificas_perfil',
  'conceitos',
  'proposta',
];

class EtapaRelogio {
  const EtapaRelogio(this.chave, this.nome, this.minutos, this.rotulo);

  final String chave;
  final String nome;
  final int minutos;
  final String rotulo;
}

const etapasRelogio = <EtapaRelogio>[
  EtapaRelogio('expectativa', 'Apresentação e alinhamento', 3, '3 min'),
  EtapaRelogio('acolhimento', 'Questões de acolhimento', 7, '7 min'),
  EtapaRelogio('experiencia', 'Experiência do cliente', 5, '5 min'),
  EtapaRelogio('especificas', 'Questões específicas', 5, '5 min'),
  EtapaRelogio('perfil', 'Definição do perfil', 2, '2 min'),
  EtapaRelogio('acolhimento_perfil', 'Acolhimento do perfil', 7, '7 min'),
  EtapaRelogio('experiencia_perfil', 'Experiência do perfil', 5, '5 min'),
  EtapaRelogio('especificas_perfil', 'Tema do perfil', 5, '5 min'),
  EtapaRelogio('conceitos', 'Conceitos', 10, '10 min'),
  EtapaRelogio('proposta', 'Proposta', 10, '5 a 10 min'),
];
const chaveOrientacaoConceitos = 'orientacao.conceitos';
const chaveOrientacaoProposta = 'orientacao.proposta';
const chaveOrientacaoAcolhimento = 'orientacao.acolhimento';
const chaveOrientacaoExperiencia = 'orientacao.experiencia';
const chaveOrientacaoEspecificas = 'orientacao.especificas';

String textoEtapa(Map<String, String> editadas, String id, String padrao) {
  final custom = editadas[id]?.trim();
  if (custom == null || custom.isEmpty) return padrao;
  return custom;
}

/// Guarda só o que diverge do roteiro. Texto vazio ou igual ao padrão sai do mapa.
Map<String, String> definirEtapa(
  Map<String, String> editadas,
  String id,
  String valor,
  String padrao,
) {
  final proximo = Map<String, String>.from(editadas);
  final texto = valor.trim();
  if (texto.isEmpty || texto == padrao.trim()) {
    proximo.remove(id);
  } else {
    proximo[id] = texto;
  }
  return proximo;
}

Map<String, String> lerEtapas(String json) => lerMontagem(json).textos;

String gravarEtapas(Map<String, String> etapas) => jsonEncode(etapas);

class ExtraBloco {
  const ExtraBloco({
    required this.id,
    required this.etapa,
    required this.tipo,
    required this.texto,
  });

  final String id;
  final String etapa;
  final String tipo;
  final String texto;
}

class Montagem {
  const Montagem({
    required this.textos,
    required this.extras,
    required this.ordem,
    this.importancia = const {},
    this.tempos = const {},
  });

  final Map<String, String> textos;
  final List<ExtraBloco> extras;
  final Map<String, List<String>> ordem;
  final Map<String, String> importancia;
  final Map<String, int> tempos;

  static Montagem vazia() => const Montagem(textos: {}, extras: [], ordem: {});
}

Montagem lerMontagem(String json) {
  try {
    final data = jsonDecode(json);
    if (data is! Map) return Montagem.vazia();
    if (data['v'] == 2) {
      final textosBrutos = data['textos'];
      return Montagem(
        textos: textosBrutos is Map
            ? textosBrutos.map((chave, valor) => MapEntry(chave.toString(), valor?.toString() ?? ''))
            : {},
        extras: _lerExtras(data['extras']),
        ordem: _lerOrdem(data['ordem']),
        importancia: _lerImportancia(data['importancia']),
        tempos: _lerTempos(data['tempos']),
      );
    }
    return Montagem(
      textos: {
        for (final entrada in data.entries)
          if (entrada.value is String || entrada.value == null)
            entrada.key.toString(): entrada.value?.toString() ?? '',
      },
      extras: const [],
      ordem: const {},
    );
  } on FormatException {
    return Montagem.vazia();
  }
}

String gravarMontagem(Montagem montagem) {
  return jsonEncode({
    'v': 2,
    'textos': montagem.textos,
    'extras': [
      for (final extra in montagem.extras)
        {'id': extra.id, 'etapa': extra.etapa, 'tipo': extra.tipo, 'texto': extra.texto},
    ],
    'ordem': montagem.ordem,
    if (montagem.importancia.isNotEmpty) 'importancia': montagem.importancia,
    if (montagem.tempos.isNotEmpty) 'tempos': montagem.tempos,
  });
}

Map<String, int> _lerTempos(Object? valor) {
  if (valor is! Map) return const {};
  final mapa = <String, int>{};
  for (final entrada in valor.entries) {
    final chave = entrada.key.toString();
    if (!etapasMontagem.contains(chave)) continue;
    final numero = entrada.value is num ? (entrada.value as num).toInt() : int.tryParse('${entrada.value}');
    if (numero != null && numero > 0) mapa[chave] = numero;
  }
  return mapa;
}

Map<String, String> _lerImportancia(Object? valor) {
  if (valor is! Map) return const {};
  const validas = {importanciaAlta, importanciaMedia, importanciaBaixa};
  return {
    for (final entrada in valor.entries)
      if (validas.contains(entrada.value?.toString()))
        entrada.key.toString(): entrada.value.toString(),
  };
}

Object etapasParaNuvem(String json) {
  try {
    final data = jsonDecode(json);
    if (data is Map) return data;
  } on FormatException {
    return {};
  }
  return {};
}

String etapasDaNuvem(Object? valor) {
  if (valor is Map || valor is List) return jsonEncode(valor);
  return '{}';
}

Map<String, List<String>> padraoPorPerfil(PerfilRoteiro? perfil) {
  List<String> perguntas(EtapaPerguntas etapa) {
    if (perfil == null) return const [];
    return [
      for (final pergunta in perfil.daEtapa(etapa)) ...[pergunta.id, '$prefixoCampo${pergunta.id}'],
    ];
  }

  List<String> comuns(List<Pergunta> lista) {
    return [
      for (final pergunta in lista) ...[pergunta.id, '$prefixoCampo${pergunta.id}'],
    ];
  }

  return {
    'expectativa': [
      chaveOrientacaoExpectativa,
      ...comuns(perguntasPadraoExpectativa),
      chavePerguntaExpectativa,
      chaveCampoExpectativa,
      chaveLigamentoExpectativa,
    ],
    'acolhimento': [chaveOrientacaoAcolhimento, ...comuns(perguntasPadraoAcolhimento)],
    'experiencia': [chaveOrientacaoExperiencia, ...comuns(perguntasPadraoExperiencia)],
    'especificas': [chaveOrientacaoEspecificas, ...comuns(perguntasPadraoEspecificas)],
    'acolhimento_perfil': perguntas(EtapaPerguntas.acolhimento),
    'experiencia_perfil': perguntas(EtapaPerguntas.experiencia),
    'especificas_perfil': perguntas(EtapaPerguntas.especificas),
    'conceitos': [chavePlanoConceitos, chaveCampoConceitos],
    'proposta': [chaveTextoProposta, chaveCampoProposta],
  };
}

String? textoPadraoBloco(String id, PerfilRoteiro? perfil) {
  final fixo = switch (id) {
    chaveOrientacaoExpectativa => orientacaoExpectativa,
    chaveOrientacaoAcolhimento => orientacaoAcolhimento,
    chaveOrientacaoExperiencia => orientacaoExperiencia,
    chaveOrientacaoEspecificas => orientacaoEspecificas,
    chaveOrientacaoConceitos => orientacaoConceitos,
    chaveOrientacaoProposta => orientacaoProposta,
    chavePerguntaExpectativa => perguntaChave,
    chaveLigamentoExpectativa => ligamentoExpectativa,
    chavePlanoConceitos => planoDeAcao(perfil?.id),
    chaveTextoProposta => propostaComercial(perfil?.id),
    _ => null,
  };
  if (fixo != null) return fixo;
  for (final pergunta in [
    ...perguntasPadraoExpectativa,
    ...perguntasPadraoAcolhimento,
    ...perguntasPadraoExperiencia,
    ...perguntasPadraoEspecificas,
  ]) {
    if (pergunta.id == id) return pergunta.texto;
  }
  if (perfil == null) return null;
  for (final etapa in EtapaPerguntas.values) {
    for (final pergunta in perfil.daEtapa(etapa)) {
      if (pergunta.id == id) return pergunta.texto;
    }
  }
  return null;
}

Map<String, List<String>> ordemEfetiva({
  required Map<String, List<String>> salva,
  required Map<String, List<String>> padrao,
  required List<ExtraBloco> extras,
}) {
  final todosPadrao = padrao.values.expand((ids) => ids).toSet();
  final extrasPorId = {for (final extra in extras) extra.id: extra};
  final usados = <String>{};
  final resultado = {for (final etapa in etapasMontagem) etapa: <String>[]};

  for (final etapa in etapasMontagem) {
    final lista = salva[etapa];
    if (lista == null) continue;
    for (final id in lista) {
      if (usados.contains(id)) continue;
      if (!todosPadrao.contains(id) && !extrasPorId.containsKey(id)) continue;
      resultado[etapa]!.add(id);
      usados.add(id);
    }
  }

  for (final etapa in etapasMontagem) {
    for (final id in padrao[etapa] ?? const <String>[]) {
      if (usados.contains(id)) continue;
      resultado[etapa]!.add(id);
      usados.add(id);
    }
  }

  for (final extra in extras) {
    if (usados.contains(extra.id)) continue;
    final etapa = etapasMontagem.contains(extra.etapa) ? extra.etapa : 'acolhimento';
    resultado[etapa]!.add(extra.id);
    usados.add(extra.id);
  }
  return resultado;
}

Map<String, List<String>> moverBloco(
  Map<String, List<String>> ordem,
  String etapa,
  int indice,
  int direcao,
) {
  final copia = {for (final nome in etapasMontagem) nome: List<String>.from(ordem[nome] ?? const <String>[])};
  final lista = copia[etapa];
  if (lista == null || indice < 0 || indice >= lista.length) return copia;
  final destino = indice + direcao;
  if (destino >= 0 && destino < lista.length) {
    final id = lista.removeAt(indice);
    lista.insert(destino, id);
    return copia;
  }
  final posicao = etapasMontagem.indexOf(etapa);
  if (destino < 0 && posicao > 0) {
    final id = lista.removeAt(indice);
    copia[etapasMontagem[posicao - 1]]!.add(id);
  } else if (destino >= lista.length && posicao >= 0 && posicao < etapasMontagem.length - 1) {
    final id = lista.removeAt(indice);
    copia[etapasMontagem[posicao + 1]]!.insert(0, id);
  }
  return copia;
}

List<ExtraBloco> _lerExtras(Object? valor) {
  if (valor is! List) return const [];
  final lista = <ExtraBloco>[];
  for (final item in valor) {
    if (item is! Map) continue;
    final id = item['id']?.toString() ?? '';
    if (id.isEmpty) continue;
    final etapa = item['etapa']?.toString() ?? 'acolhimento';
    lista.add(
      ExtraBloco(
        id: id,
        etapa: etapasMontagem.contains(etapa) ? etapa : 'acolhimento',
        tipo: item['tipo']?.toString() == 'campo' ? 'campo' : 'texto',
        texto: item['texto']?.toString() ?? '',
      ),
    );
  }
  return lista;
}

Map<String, List<String>> _lerOrdem(Object? valor) {
  if (valor is! Map) return const {};
  return {
    for (final entrada in valor.entries)
      entrada.key.toString(): [
        if (entrada.value is List)
          for (final item in entrada.value as List) item.toString(),
      ],
  };
}
