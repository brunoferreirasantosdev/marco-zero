import 'dart:math';

String novoId() {
  final aleatorio = Random.secure().nextInt(1 << 32).toRadixString(16);
  return '${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}$aleatorio';
}
