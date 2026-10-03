import 'dart:convert';

import 'script/etapas.dart';

class Preferencias {
  const Preferencias({
    required this.minutos,
    required this.corAlta,
    required this.corMedia,
    required this.corBaixa,
  });

  final Map<String, int> minutos;
  final int corAlta;
  final int corMedia;
  final int corBaixa;

  static const corAltaPadrao = 0xFFD5455F;
  static const corMediaPadrao = 0xFFB86E00;
  static const corBaixaPadrao = 0xFF8A877C;

  static Preferencias get padrao => Preferencias(
    minutos: {for (final etapa in etapasRelogio) etapa.chave: etapa.minutos},
    corAlta: corAltaPadrao,
    corMedia: corMediaPadrao,
    corBaixa: corBaixaPadrao,
  );

  int minutosDe(String chave) {
    return minutos[chave] ?? padrao.minutos[chave] ?? 5;
  }

  int? corDoNivel(String? nivel) {
    return switch (nivel) {
      importanciaAlta => corAlta,
      importanciaMedia => corMedia,
      importanciaBaixa => corBaixa,
      _ => null,
    };
  }

  /// O minuto da reunião vale quando existe. Sem ele, vale a preferência.
  static int minutosEfetivos({required int? daReuniao, required int daPreferencia}) {
    if (daReuniao == null || daReuniao <= 0) return daPreferencia;
    return daReuniao;
  }
}

String gravarPreferencias(Preferencias prefs) {
  return jsonEncode({
    'minutos': prefs.minutos,
    'corAlta': prefs.corAlta,
    'corMedia': prefs.corMedia,
    'corBaixa': prefs.corBaixa,
  });
}

Preferencias lerPreferencias(String json) {
  final base = Preferencias.padrao;
  try {
    final data = jsonDecode(json);
    if (data is! Map) return base;
    final minutos = Map<String, int>.from(base.minutos);
    final brutos = data['minutos'];
    if (brutos is Map) {
      for (final entrada in brutos.entries) {
        final chave = entrada.key.toString();
        if (!minutos.containsKey(chave)) continue;
        final numero = entrada.value is num ? (entrada.value as num).toInt() : int.tryParse('${entrada.value}');
        if (numero != null && numero > 0) minutos[chave] = numero;
      }
    }
    int cor(Object? valor, int padrao) {
      final numero = valor is num ? valor.toInt() : int.tryParse('$valor');
      if (numero == null || numero < 0) return padrao;
      return numero;
    }

    return Preferencias(
      minutos: minutos,
      corAlta: cor(data['corAlta'], base.corAlta),
      corMedia: cor(data['corMedia'], base.corMedia),
      corBaixa: cor(data['corBaixa'], base.corBaixa),
    );
  } on FormatException {
    return base;
  }
}
