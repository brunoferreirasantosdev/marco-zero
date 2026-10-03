import '../local/banco.dart';

abstract class SyncRemoto {
  Future<List<Cliente>> puxarClientes(String uid);

  Future<List<Reuniao>> puxarReunioes(String uid, String clienteId);

  Future<void> enviarCliente(Cliente cliente);

  Future<void> enviarReuniao(Reuniao reuniao);

  Future<void> apagarCliente(String uid, String clienteId);
}
