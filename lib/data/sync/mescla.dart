class PlanoMescla {
  const PlanoMescla({required this.puxar, required this.enviar});

  final List<String> puxar;
  final List<String> enviar;
}

/// [local] e [remoto] mapeiam id para updatedAt em milissegundos.
PlanoMescla planejarMescla(Map<String, int> local, Map<String, int> remoto) {
  final ids = {...local.keys, ...remoto.keys};
  final puxar = <String>[];
  final enviar = <String>[];
  for (final id in ids) {
    final aqui = local[id];
    final la = remoto[id];
    if (aqui == null && la != null) {
      puxar.add(id);
    } else if (la == null && aqui != null) {
      enviar.add(id);
    } else if (la != null && aqui != null && la > aqui) {
      puxar.add(id);
    } else if (la != null && aqui != null && aqui > la) {
      enviar.add(id);
    }
  }
  return PlanoMescla(puxar: puxar, enviar: enviar);
}
