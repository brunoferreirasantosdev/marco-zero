import '../data/script/roteiro.dart';

String? motivoParadaInicial({
  required String expectativa,
  required PerfilId? perfil,
}) {
  if (expectativa.trim().isEmpty) return 'Registre a expectativa do encontro.';
  if (perfil == null) return 'Confirme o perfil antes de seguir.';
  return null;
}

String formatarDuracao(Duration decorrido) {
  final total = decorrido.inSeconds;
  final horas = total ~/ 3600;
  final minutos = (total % 3600) ~/ 60;
  final segundos = total % 60;
  String dois(int n) => n.toString().padLeft(2, '0');
  if (horas > 0) return '$horas:${dois(minutos)}:${dois(segundos)}';
  return '${dois(minutos)}:${dois(segundos)}';
}

bool tempoAcimaDaMeta(Duration decorrido, int minutos) {
  return decorrido.inSeconds > minutos * 60;
}
