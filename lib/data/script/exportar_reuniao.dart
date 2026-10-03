import 'etapas.dart';
import 'roteiro.dart';

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
  return buffer.toString().trimRight();
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
