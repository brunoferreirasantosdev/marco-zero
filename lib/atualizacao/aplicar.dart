import 'dart:io';

import 'package:http/http.dart' as http;

/// Baixa o pacote, pede a um processo separado para trocar os arquivos
/// e encerra este processo para o executável deixar de estar em uso.
Future<void> baixarEAplicar(Uri url) async {
  final resposta = await http.get(url);
  if (resposta.statusCode != 200) {
    throw Exception('Download recusado (${resposta.statusCode}).');
  }
  final temporario = await Directory.systemTemp.createTemp('marco-zero-');
  final nome = url.pathSegments.isEmpty ? 'pacote.zip' : url.pathSegments.last;
  final arquivo = File('${temporario.path}\\$nome');
  await arquivo.writeAsBytes(resposta.bodyBytes);

  final executavel = Platform.resolvedExecutable;
  final destino = File(executavel).parent.path;
  if (arquivo.path.toLowerCase().endsWith('.exe')) {
    await Process.start(
      arquivo.path,
      const [],
      mode: ProcessStartMode.detached,
      environment: const {},
    );
  } else {
    final script = File('${temporario.path}\\aplicar.ps1');
    await script.writeAsString(_script(
      pidProcesso: pid,
      zip: arquivo.path,
      destino: destino,
      executavel: executavel,
    ));
    await Process.start(
      'powershell',
      [
        '-NoProfile',
        '-ExecutionPolicy',
        'Bypass',
        '-File',
        script.path,
      ],
      mode: ProcessStartMode.detached,
      environment: const {},
    );
  }
  exit(0);
}

String _ps(String valor) => "'${valor.replaceAll("'", "''")}'";

String _script({
  required int pidProcesso,
  required String zip,
  required String destino,
  required String executavel,
}) {
  return '''
\$alvo = $pidProcesso
while (Get-Process -Id \$alvo -ErrorAction SilentlyContinue) {
  Start-Sleep -Milliseconds 400
}
Start-Sleep -Seconds 1
\$extraido = Join-Path \$env:TEMP ('mz-extraido-' + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path \$extraido | Out-Null
Expand-Archive -LiteralPath ${_ps(zip)} -DestinationPath \$extraido -Force
\$itens = @(Get-ChildItem -LiteralPath \$extraido)
\$fonte = \$extraido
if (\$itens.Count -eq 1 -and \$itens[0].PSIsContainer) { \$fonte = \$itens[0].FullName }
Copy-Item -Path (Join-Path \$fonte '*') -Destination ${_ps(destino)} -Recurse -Force
Start-Process -FilePath ${_ps(executavel)}
''';
}
