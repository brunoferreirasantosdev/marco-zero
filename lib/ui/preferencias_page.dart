import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/preferencias.dart';
import '../data/script/etapas.dart';
import 'escopo.dart';
import 'tema.dart';

const _paleta = <int>[
  0xFFD5455F,
  0xFFB86E00,
  0xFF8A877C,
  0xFF27BB4E,
  0xFF1F1F21,
  0xFF1F6FEB,
  0xFF7A3E9D,
  0xFF0E7C66,
  0xFFC45C26,
  0xFF3D5A80,
];

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({super.key});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  final _minutos = <String, TextEditingController>{};
  var _corAlta = Preferencias.corAltaPadrao;
  var _corMedia = Preferencias.corMediaPadrao;
  var _corBaixa = Preferencias.corBaixaPadrao;
  var _salvando = false;

  @override
  void initState() {
    super.initState();
    for (final etapa in etapasRelogio) {
      _minutos[etapa.chave] = TextEditingController(text: '${etapa.minutos}');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _preencher());
  }

  void _preencher() {
    final prefs = Escopo.of(context).preferencias;
    for (final etapa in etapasRelogio) {
      _minutos[etapa.chave]!.text = '${prefs.minutosDe(etapa.chave)}';
    }
    setState(() {
      _corAlta = prefs.corAlta;
      _corMedia = prefs.corMedia;
      _corBaixa = prefs.corBaixa;
    });
  }

  @override
  void dispose() {
    for (final campo in _minutos.values) {
      campo.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    final minutos = <String, int>{};
    for (final etapa in etapasRelogio) {
      final numero = int.tryParse(_minutos[etapa.chave]!.text.trim());
      minutos[etapa.chave] = numero == null || numero <= 0 ? etapa.minutos : numero;
    }
    setState(() => _salvando = true);
    await Escopo.of(context).guardarPreferencias(
      Preferencias(minutos: minutos, corAlta: _corAlta, corMedia: _corMedia, corBaixa: _corBaixa),
    );
    if (!mounted) return;
    context.pop();
  }

  Future<void> _escolherCor(String nivel) async {
    final atual = switch (nivel) {
      'alta' => _corAlta,
      'media' => _corMedia,
      _ => _corBaixa,
    };
    final escolhida = await showDialog<int>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(rotuloImportancia(nivel)),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final cor in _paleta)
              InkWell(
                onTap: () => Navigator.pop(contexto, cor),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(cor),
                    shape: BoxShape.circle,
                    border: Border.all(color: cor == atual ? carvao : branco, width: 3),
                  ),
                ),
              ),
          ],
        ),
        actions: [OutlinedButton(onPressed: () => Navigator.pop(contexto), child: const Text('Cancelar'))],
      ),
    );
    if (escolhida == null) return;
    setState(() {
      switch (nivel) {
        case 'alta':
          _corAlta = escolhida;
        case 'media':
          _corMedia = escolhida;
        default:
          _corBaixa = escolhida;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferências'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Tempo de cada etapa', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Este tempo vale para as reuniões que não tiverem um minuto próprio.'),
              const SizedBox(height: 12),
              for (final etapa in etapasRelogio) ...[
                Row(
                  children: [
                    Expanded(child: Text(etapa.nome)),
                    SizedBox(
                      width: 88,
                      child: TextField(
                        controller: _minutos[etapa.chave],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Minutos'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              Text('Cores de importância', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Toque na cor para trocar. As perguntas marcadas passam a usar a nova cor.'),
              const SizedBox(height: 12),
              _linhaCor('alta', _corAlta),
              _linhaCor('media', _corMedia),
              _linhaCor('baixa', _corBaixa),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _salvando ? null : _salvar,
                child: Text(_salvando ? 'Salvando...' : 'Salvar preferências'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linhaCor(String nivel, int cor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () => _escolherCor(nivel),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: Color(cor), shape: BoxShape.circle, border: Border.all(color: carvao)),
            ),
          ),
          const SizedBox(width: 12),
          Text(rotuloImportancia(nivel)),
        ],
      ),
    );
  }
}
