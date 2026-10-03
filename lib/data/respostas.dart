import 'dart:convert';

Map<String, String> lerRespostas(String json) {
  try {
    final data = jsonDecode(json);
    if (data is! Map) return {};
    return {
      for (final entrada in data.entries)
        entrada.key.toString(): entrada.value?.toString() ?? '',
    };
  } on FormatException {
    return {};
  }
}

String gravarRespostas(Map<String, String> respostas) => jsonEncode(respostas);
