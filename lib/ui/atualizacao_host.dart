import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../atualizacao/aplicar.dart';
import '../atualizacao/feed.dart';
import '../atualizacao/versao.dart';

class AtualizacaoHost extends StatefulWidget {
  const AtualizacaoHost({
    super.key,
    required this.child,
    required this.navegador,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navegador;

  @override
  State<AtualizacaoHost> createState() => _AtualizacaoHostState();
}

class _AtualizacaoHostState extends State<AtualizacaoHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contexto = widget.navegador.currentContext;
      if (contexto != null && contexto.mounted) {
        verificarAtualizacao(contexto);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Future<void> verificarAtualizacao(BuildContext context, {bool manual = false}) async {
  if (kDebugMode) {
    if (manual && context.mounted) {
      _avisar(context, 'A troca de arquivos só ocorre na versão publicada, não no flutter run.');
    }
    return;
  }

  final aoLado = _lerArquivoAoLado();
  final url = resolverUrlFeed(conteudoArquivo: aoLado, compilada: feedCompilado);
  if (url.isEmpty) {
    if (manual && context.mounted) {
      _avisar(context, 'Nenhum endereço de atualização foi definido nesta instalação.');
    }
    return;
  }

  try {
    final info = await PackageInfo.fromPlatform();
    final resposta = await http.get(Uri.parse(url));
    if (resposta.statusCode != 200) {
      throw Exception('Feed respondeu ${resposta.statusCode}.');
    }
    final oferta = interpretarFeed(resposta.body, info.version);
    if (!context.mounted) return;
    if (oferta == null) {
      if (manual) _avisar(context, 'Esta instalação já está na versão ${info.version}.');
      return;
    }
    if (Navigator.maybeOf(context) == null) return;
    final aceitou = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text('Versão ${oferta.versao} disponível'),
        content: Text(
          oferta.notas.isEmpty
              ? 'O app pode baixar e se atualizar agora. A reunião em andamento deve ser salva antes.'
              : oferta.notas,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(contexto, false), child: const Text('Agora não')),
          FilledButton(onPressed: () => Navigator.pop(contexto, true), child: const Text('Atualizar')),
        ],
      ),
    );
    if (aceitou == true) {
      await baixarEAplicar(Uri.parse(oferta.url));
    }
  } on FeedInvalido {
    if (context.mounted) _avisar(context, 'O anúncio da versão nova está incompleto.');
  } catch (erro) {
    if (context.mounted) {
      _avisar(context, 'Não foi possível atualizar. A versão atual continua em uso. $erro');
    }
  }
}

String? _lerArquivoAoLado() {
  final arquivo = File('${File(Platform.resolvedExecutable).parent.path}\\feed_atualizacao.txt');
  if (!arquivo.existsSync()) return null;
  return arquivo.readAsStringSync();
}

void _avisar(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
}
