import 'dart:async';
import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/ids.dart';
import '../data/local/banco.dart';
import '../data/respostas.dart';
import '../data/preferencias.dart';
import '../data/script/etapas.dart';
import '../data/script/exportar_reuniao.dart';
import '../data/script/roteiro.dart';
import '../data/script/sugerir_perfil.dart';
import 'escopo.dart';
import 'reuniao_regras.dart';
import 'tema.dart';

class ReuniaoPage extends StatefulWidget {
  const ReuniaoPage({
    super.key,
    this.reuniaoId,
    this.clienteId,
    this.preparando = false,
  });

  final String? reuniaoId;
  final String? clienteId;
  final bool preparando;

  @override
  State<ReuniaoPage> createState() => _ReuniaoPageState();
}

class _ReuniaoPageState extends State<ReuniaoPage> {
  final _expectativa = TextEditingController();
  final _notasPlano = TextEditingController();
  final _notasProposta = TextEditingController();
  final _campos = <String, TextEditingController>{};
  final _rotulos = <String, TextEditingController>{};

  String? _reuniaoId;
  String? _clienteId;
  String _nomeCliente = '';
  PerfilId? _perfil;
  final _decorridos = List<Duration>.filled(
    etapasRelogio.length,
    Duration.zero,
  );
  final _correndo = List<bool>.filled(etapasRelogio.length, false);
  var _tempos = <String, int>{};
  Timer? _relogio;
  var _passo = 0;
  var _pronto = false;
  var _salvando = false;
  String? _aviso;
  final _respostas = <String, String>{};
  var _montagem = Montagem.vazia();
  var _importancia = <String, String>{};
  var _ordem = <String, List<String>>{};
  var _posicionando = false;
  var _etapasJson = '{}';

  @override
  void initState() {
    super.initState();
    _expectativa.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  Future<void> _carregar() async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null) return;
    _reuniaoId = widget.reuniaoId;
    final clienteInicial = widget.clienteId == null
        ? null
        : await repo.obterCliente(widget.clienteId!);
    if (clienteInicial != null) {
      _clienteId = clienteInicial.id;
      _nomeCliente = clienteInicial.nome;
    }
    if (_reuniaoId != null) {
      final reuniao = await repo.obterReuniao(_reuniaoId!);
      if (reuniao != null) {
        final cliente = await repo.obterCliente(reuniao.clienteId);
        if (cliente != null) {
          _clienteId = cliente.id;
          _nomeCliente = cliente.nome;
        }
        _expectativa.text = reuniao.expectativa;
        _notasPlano.text = reuniao.notasPlano;
        _notasProposta.text = reuniao.notasProposta;
        _perfil = perfilPorNome(reuniao.perfil)?.id;
        _respostas.addAll(lerRespostas(reuniao.respostasJson));
        _montagem = lerMontagem(reuniao.etapasJson);
        _importancia = Map<String, String>.from(_montagem.importancia);
        _tempos = Map<String, int>.from(_montagem.tempos);
        _etapasJson = reuniao.etapasJson;
        _sincronizarOrdem();
      }
    }
    if (mounted) setState(() => _pronto = true);
  }

  @override
  void dispose() {
    _relogio?.cancel();
    _expectativa.dispose();
    _notasPlano.dispose();
    _notasProposta.dispose();
    for (final campo in _campos.values) {
      campo.dispose();
    }
    for (final campo in _rotulos.values) {
      campo.dispose();
    }
    super.dispose();
  }

  TextEditingController _campo(String id) {
    return _campos.putIfAbsent(
      id,
      () => TextEditingController(text: _respostas[id] ?? ''),
    );
  }

  void _coletarRespostas() {
    for (final entrada in _campos.entries) {
      _respostas[entrada.key] = entrada.value.text;
    }
  }

  Future<bool> _salvar({required bool concluir}) async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null || _clienteId == null) return false;
    _coletarRespostas();
    if (widget.preparando) {
      final montagem = _coletarMontagem();
      _montagem = montagem;
      _etapasJson = gravarMontagem(montagem);
    }
    setState(() => _salvando = true);
    try {
      final reuniao = await repo.guardarReuniao(
        id: _reuniaoId,
        clienteId: _clienteId!,
        perfil: _perfil?.name,
        expectativa: _expectativa.text.trim(),
        respostas: _respostas,
        notasPlano: _notasPlano.text,
        notasProposta: _notasProposta.text,
        status: concluir ? 'concluida' : 'rascunho',
        etapasJson: _etapasJson,
      );
      _reuniaoId = reuniao.id;
      if (mounted) {
        setState(() => _aviso = null);
      }
      return true;
    } catch (_) {
      if (mounted) {
        setState(() => _aviso = 'Não foi possível salvar agora.');
      }
      return false;
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _avancar() async {
    if (!widget.preparando && _passo < etapasRelogio.length) {
      final chave = etapasRelogio[_passo].chave;
      if (chave == 'expectativa' && _expectativa.text.trim().isEmpty) {
        setState(() => _aviso = 'Registre a expectativa do encontro.');
        return;
      }
      if (chave == 'perfil' && _perfil == null) {
        setState(() => _aviso = 'Confirme o perfil antes de seguir.');
        return;
      }
    }
    _pausarRelogio();
    final ok = await _salvar(concluir: false);
    if (ok && mounted) setState(() => _passo += 1);
  }

  void _pausarRelogio() {
    _relogio?.cancel();
    _relogio = null;
    for (var i = 0; i < _correndo.length; i++) {
      _correndo[i] = false;
    }
  }

  void _alternarRelogio() {
    if (_passo >= _decorridos.length) return;
    if (_correndo[_passo]) {
      setState(_pausarRelogio);
      return;
    }
    setState(() => _correndo[_passo] = true);
    _relogio ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        for (var i = 0; i < _correndo.length; i++) {
          if (_correndo[i]) _decorridos[i] += const Duration(seconds: 1);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_pronto) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_clienteId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reunião'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('Cadastre o cliente antes de iniciar a reunião.'),
        ),
      );
    }
    final sugestao = sugerirPerfil(
      '${_expectativa.text} ${_respostas.values.join(' ')} ${_campos.values.map((campo) => campo.text).join(' ')}',
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloPasso()),
        actions: [
          if (_reuniaoId != null && !widget.preparando)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: OutlinedButton(
                  style: _estiloNaBarra,
                  onPressed: () async {
                    _pausarRelogio();
                    final ok = await _salvar(concluir: false);
                    if (!ok || !context.mounted) return;
                    await context.push('/reuniao/$_reuniaoId/etapas');
                    if (!context.mounted) return;
                    final repo = Escopo.of(context).repositorio;
                    final reuniao = await repo?.obterReuniao(_reuniaoId!);
                    if (reuniao != null && mounted) {
                      setState(() {
                        _montagem = lerMontagem(reuniao.etapasJson);
                        _importancia = Map<String, String>.from(
                          _montagem.importancia,
                        );
                        _tempos = Map<String, int>.from(_montagem.tempos);
                        _etapasJson = reuniao.etapasJson;
                        _sincronizarOrdem();
                      });
                    }
                  },
                  child: const Text('Preparar'),
                ),
              ),
            ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_passo + 1) / (etapasRelogio.length + 1),
          ),
          if (!widget.preparando && _passo < etapasRelogio.length)
            _relogioEtapa(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (_aviso != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _aviso!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ..._conteudo(sugestao),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                if (_passo > 0)
                  OutlinedButton(
                    onPressed: _salvando
                        ? null
                        : () => setState(() {
                            _pausarRelogio();
                            _passo -= 1;
                          }),
                    child: const Text('Voltar'),
                  ),
                if (widget.preparando && _etapaDoPasso() != null)
                  OutlinedButton(
                    onPressed: () =>
                        setState(() => _posicionando = !_posicionando),
                    child: Text(
                      _posicionando
                          ? 'Concluir posição'
                          : 'Editar posicionamento',
                    ),
                  ),
                if (widget.preparando) ...[
                  OutlinedButton(
                    onPressed: _salvando ? null : _salvarComoModelo,
                    child: const Text('Salvar como modelo'),
                  ),
                  OutlinedButton(
                    onPressed: _salvando ? null : _importarModelo,
                    child: const Text('Importar modelo'),
                  ),
                ],
                OutlinedButton(
                  onPressed: _salvando ? null : _exportar,
                  child: const Text('Exportar'),
                ),
                if (_passo < etapasRelogio.length)
                  FilledButton(
                    onPressed: _salvando ? null : _avancar,
                    child: Text(_salvando ? 'Salvando...' : 'Continuar'),
                  ),
                if (widget.preparando)
                  FilledButton(
                    onPressed: _salvando ? null : _finalizarPreparacao,
                    child: Text(
                      _salvando ? 'Salvando...' : 'Salvar preparação',
                    ),
                  ),
                if (!widget.preparando && _passo == etapasRelogio.length)
                  FilledButton(
                    onPressed: _salvando
                        ? null
                        : () async {
                            final ok = await _salvar(concluir: true);
                            if (ok && context.mounted) context.pop();
                          },
                    child: Text(_salvando ? 'Salvando...' : 'Concluir'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Preferencias get _prefs => Escopo.of(context).preferencias;

  Color? _corNivel(String? nivel) {
    final valor = _prefs.corDoNivel(nivel);
    if (valor == null) return null;
    return Color(valor);
  }

  String _tituloPasso() {
    if (_passo >= etapasRelogio.length) return 'Resumo';
    return etapasRelogio[_passo].nome;
  }

  int _minutosDa(EtapaRelogio etapa) {
    return Preferencias.minutosEfetivos(
      daReuniao: _tempos[etapa.chave],
      daPreferencia: _prefs.minutosDe(etapa.chave),
    );
  }

  int _minutosDoPasso() => _minutosDa(etapasRelogio[_passo]);

  List<Widget> _conteudo(PerfilId? sugestao) {
    if (_passo >= etapasRelogio.length) return _resumo();
    final chave = etapasRelogio[_passo].chave;
    final perfil = _perfil == null ? null : perfilPorId(_perfil!);
    final titulo = switch (chave) {
      'conceitos' => 'Conceito e plano',
      'proposta' => 'Proposta',
      'acolhimento_perfil' || 'experiencia_perfil' || 'especificas_perfil' =>
        perfil?.titulo ?? 'Confirme o perfil na etapa de escolha do perfil',
      _ => null,
    };
    return [
      if (chave == 'expectativa') ...[
        Text(_nomeCliente, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
      ],
      if (titulo != null) ...[
        Text(titulo, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
      ],
      if (chave != 'perfil') ..._pecas(chave),
      if (widget.preparando && chave != 'perfil') ..._botoesNovos(),
      if (chave == 'perfil') ..._cardsPerfil(sugestao),
    ];
  }

  List<Widget> _cardsPerfil(PerfilId? sugestao) {
    return [
      const SizedBox(height: 8),
      Text('Confirme o perfil', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final perfil in roteiro)
            _CardPerfil(
              perfil: perfil,
              selecionado: _perfil == perfil.id,
              sugerido: sugestao == perfil.id,
              aoTocar: () => setState(() {
                _perfil = perfil.id;
                _ordem = ordemEfetiva(
                  salva: _ordem,
                  padrao: padraoPorPerfil(perfilPorId(perfil.id)),
                  extras: _montagem.extras,
                );
              }),
            ),
        ],
      ),
    ];
  }

  List<Widget> _pecas(String etapa) {
    final perfil = _perfil == null ? null : perfilPorId(_perfil!);
    final ids = widget.preparando
        ? List<String>.from(_ordem[etapa] ?? const <String>[])
        : List<String>.from(
            ordemEfetiva(
                  salva: _montagem.ordem,
                  padrao: padraoPorPerfil(perfil),
                  extras: _montagem.extras,
                )[etapa] ??
                const <String>[],
          );
    final extras = {for (final extra in _montagem.extras) extra.id: extra};
    final itens = <Widget>[];
    final estiloPergunta = Theme.of(context).textTheme.titleMedium;
    for (var i = 0; i < ids.length; i++) {
      final id = ids[i];
      final extra = extras[id];
      final miolo = <Widget>[];
      if (extra != null) {
        final rotulo = _rotulos[extra.id]?.text ?? extra.texto;
        if (extra.tipo == 'campo') {
          miolo.addAll(
            _blocoTexto(
              extra.id,
              rotulo.isEmpty ? 'Campo' : rotulo,
              caixa: false,
              estilo: estiloPergunta,
            ),
          );
          miolo.add(const SizedBox(height: 6));
          miolo.add(_campoResposta(_campo(extra.id)));
        } else {
          miolo.addAll(
            _blocoTexto(
              extra.id,
              rotulo.isEmpty ? 'Caixa de pergunta' : rotulo,
              caixa: false,
              estilo: estiloPergunta,
            ),
          );
        }
      } else if (id == chaveCampoExpectativa) {
        miolo.add(_campoResposta(_expectativa, minLines: 3, maxLines: 6));
      } else if (id == chaveCampoConceitos || id == chaveCampoProposta) {
        final campo = id == chaveCampoConceitos ? _notasPlano : _notasProposta;
        if (!widget.preparando) {
          miolo.add(const Text('Anotações deste bloco'));
          miolo.add(const SizedBox(height: 6));
        }
        miolo.add(_campoResposta(campo, minLines: 5, maxLines: 10));
      } else if (id.startsWith(prefixoCampo)) {
        miolo.add(
          _campoResposta(
            _campo(id.substring(prefixoCampo.length)),
            minLines: 2,
            maxLines: 5,
          ),
        );
      } else {
        final padrao = textoPadraoBloco(id, perfil);
        if (padrao == null) continue;
        final bruto = textoEtapa(_montagem.textos, id, padrao);
        final texto = id.startsWith('orientacao.') ? _semDuracao(bruto) : bruto;
        if (id.startsWith('orientacao.')) {
          miolo.addAll(_blocoTexto(id, texto, caixa: true));
        } else if (textoDeFala(id)) {
          miolo.addAll(
            _blocoTexto(
              id,
              texto,
              caixa: false,
              estilo: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          miolo.addAll(
            _blocoTexto(id, texto, caixa: false, estilo: estiloPergunta),
          );
        }
      }
      itens.add(_envolve(etapa, i, id, miolo, extra: extra != null));
      itens.add(const SizedBox(height: 14));
    }
    return itens;
  }

  List<Widget> _resumo() {
    final perfil = _perfil == null ? null : perfilPorId(_perfil!);
    final ordem = ordemEfetiva(
      salva: _montagem.ordem,
      padrao: padraoPorPerfil(perfil),
      extras: _montagem.extras,
    );
    final extras = {for (final extra in _montagem.extras) extra.id: extra};
    final linhas = <Widget>[
      Text(
        perfil?.titulo ?? 'Sem perfil',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      Text(_nomeCliente),
      const SizedBox(height: 12),
    ];
    for (final etapa in etapasMontagem) {
      for (final id in ordem[etapa]!) {
        if (id == chaveCampoExpectativa) {
          linhas.add(
            Text(
              textoEtapa(
                _montagem.textos,
                chavePerguntaExpectativa,
                perguntaChave,
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
          linhas.add(Text(_expectativa.text));
          linhas.add(const SizedBox(height: 10));
          continue;
        }
        if (id == chaveCampoConceitos) {
          linhas.add(
            const Text('Plano', style: TextStyle(fontWeight: FontWeight.w600)),
          );
          linhas.add(
            Text(_notasPlano.text.isEmpty ? 'Sem anotação.' : _notasPlano.text),
          );
          linhas.add(const SizedBox(height: 10));
          continue;
        }
        if (id == chaveCampoProposta) {
          linhas.add(
            const Text(
              'Proposta',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          );
          linhas.add(
            Text(
              _notasProposta.text.isEmpty
                  ? 'Sem anotação.'
                  : _notasProposta.text,
            ),
          );
          linhas.add(const SizedBox(height: 10));
          continue;
        }
        final extra = extras[id];
        if (extra != null && extra.tipo == 'campo') {
          final resposta =
              (_campos[extra.id]?.text ?? _respostas[extra.id] ?? '').trim();
          if (resposta.isEmpty) continue;
          linhas.add(
            Text(
              extra.texto,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
          linhas.add(Text(resposta));
          linhas.add(const SizedBox(height: 10));
          continue;
        }
        if (!id.startsWith(prefixoCampo) || id == chaveCampoExpectativa)
          continue;
        final perguntaId = id.substring(prefixoCampo.length);
        final resposta =
            (_campos[perguntaId]?.text ?? _respostas[perguntaId] ?? '').trim();
        if (resposta.isEmpty) continue;
        final padrao = textoPadraoBloco(perguntaId, perfil) ?? 'Campo';
        linhas.add(
          Text(
            textoEtapa(_montagem.textos, perguntaId, padrao),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
        linhas.add(Text(resposta));
        linhas.add(const SizedBox(height: 10));
      }
    }
    return linhas;
  }

  void _sincronizarOrdem() {
    final perfil = _perfil == null ? null : perfilPorId(_perfil!);
    _ordem = ordemEfetiva(
      salva: _montagem.ordem,
      padrao: padraoPorPerfil(perfil),
      extras: _montagem.extras,
    );
  }

  String? _etapaDoPasso() {
    if (_passo < 0 || _passo >= etapasRelogio.length) return null;
    return etapasRelogio[_passo].chave;
  }

  TextEditingController _rotulo(String id, String inicial) {
    return _rotulos.putIfAbsent(id, () => TextEditingController(text: inicial));
  }

  List<Widget> _blocoTexto(
    String id,
    String texto, {
    required bool caixa,
    TextStyle? estilo,
    String? numerado,
  }) {
    final cor = _corNivel(_importancia[id]);
    if (widget.preparando) {
      return [
        TextField(
          controller: _rotulo(
            id,
            textoDeFala(id) ? aplicarNomeCliente(texto, _nomeCliente) : texto,
          ),
          minLines: 2,
          maxLines: textoDeFala(id) ? 18 : 8,
          style: cor == null ? null : TextStyle(color: cor),
          decoration: InputDecoration(
            labelText: caixa
                ? 'Orientação'
                : textoDeFala(id)
                ? 'Texto'
                : 'Pergunta',
          ),
        ),
        if (!caixa && !textoDeFala(id)) _seletorImportancia(id),
      ];
    }
    final editado = _rotulos[id]?.text.trim() ?? '';
    final cru = editado.isEmpty ? texto : editado;
    final visivel = textoDeFala(id)
        ? aplicarNomeCliente(cru, _nomeCliente)
        : cru;
    if (caixa) return [_caixa(visivel)];
    final mostrado = numerado == null ? visivel : '$numerado. $visivel';
    final base = estilo ?? const TextStyle();
    return [
      Text(
        mostrado,
        style: cor == null
            ? estilo
            : base.copyWith(
                color: cor,
                fontWeight: _importancia[id] == importanciaAlta
                    ? FontWeight.w700
                    : base.fontWeight,
              ),
      ),
    ];
  }

  Widget _envolve(
    String etapa,
    int indice,
    String id,
    List<Widget> miolo, {
    required bool extra,
  }) {
    final corpo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: miolo,
    );
    if (!widget.preparando || !_posicionando) return corpo;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            IconButton(
              tooltip: 'Subir',
              visualDensity: VisualDensity.compact,
              onPressed: () => _mover(etapa, indice, -1),
              icon: const Icon(Icons.arrow_upward),
            ),
            IconButton(
              tooltip: 'Descer',
              visualDensity: VisualDensity.compact,
              onPressed: () => _mover(etapa, indice, 1),
              icon: const Icon(Icons.arrow_downward),
            ),
          ],
        ),
        Expanded(child: corpo),
        if (extra)
          IconButton(
            tooltip: 'Remover',
            onPressed: () => _remover(id),
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    );
  }

  Widget _seletorImportancia(String id) {
    final atual = _importancia[id];
    Widget bolinha(String nivel, Color cor) {
      final ativo = atual == nivel;
      return Tooltip(
        message: rotuloImportancia(nivel),
        child: InkWell(
          onTap: () => setState(() {
            if (ativo) {
              _importancia.remove(id);
            } else {
              _importancia[id] = nivel;
            }
          }),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
              border: Border.all(color: ativo ? carvao : branco, width: 2),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          bolinha(importanciaAlta, Color(_prefs.corAlta)),
          const SizedBox(width: 6),
          bolinha(importanciaMedia, Color(_prefs.corMedia)),
          const SizedBox(width: 6),
          bolinha(importanciaBaixa, Color(_prefs.corBaixa)),
          const SizedBox(width: 8),
          Text(
            atual == null ? 'Importância' : rotuloImportancia(atual),
            style: TextStyle(
              color: _corNivel(atual) ?? const Color(0xFF595855),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoResposta(
    TextEditingController controller, {
    int minLines = 2,
    int maxLines = 6,
  }) {
    if (widget.preparando) {
      return const Text(
        'Campo de resposta',
        style: TextStyle(color: Color(0xFF595855)),
      );
    }
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  Future<void> _finalizarPreparacao() async {
    final ok = await _salvar(concluir: false);
    if (ok && mounted) context.pop();
  }

  Future<void> _exportar() async {
    final respostas = Map<String, String>.from(_respostas);
    respostas[chaveCampoExpectativa] = _expectativa.text;
    respostas[chaveCampoConceitos] = _notasPlano.text;
    respostas[chaveCampoProposta] = _notasProposta.text;
    for (final entrada in _campos.entries) {
      respostas[entrada.key] = entrada.value.text;
    }
    final texto = textoDaReuniao(
      nomeCliente: _nomeCliente,
      perfilId: _perfil,
      montagem: _coletarMontagem(),
      respostas: respostas,
    );
    final nome = nomeArquivoReuniao(_nomeCliente);
    final destino = await getSaveLocation(
      suggestedName: nome,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'Texto', extensions: ['txt']),
      ],
    );
    if (destino == null || !mounted) return;
    final caminho = destino.path.toLowerCase().endsWith('.txt')
        ? destino.path
        : '${destino.path}.txt';
    try {
      await XFile.fromData(
        utf8.encode(texto),
        mimeType: 'text/plain',
        name: nome,
      ).saveTo(caminho);
    } catch (_) {
      if (!mounted) return;
      setState(() => _aviso = 'Não foi possível exportar agora.');
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Reunião exportada.')));
  }

  Future<void> _salvarComoModelo() async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null) return;
    final nome = TextEditingController();
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Salvar como modelo'),
        content: TextField(
          controller: nome,
          decoration: const InputDecoration(labelText: 'Nome do modelo'),
          autofocus: true,
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Salvar modelo'),
          ),
        ],
      ),
    );
    final titulo = nome.text.trim();
    nome.dispose();
    if (confirmou != true || titulo.isEmpty || !mounted) return;
    final montagem = _coletarMontagem();
    await repo.salvarModelo(
      nome: titulo,
      perfil: _perfil?.name,
      etapasJson: gravarMontagem(montagem),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modelo "$titulo" salvo neste computador.')),
    );
  }

  Future<void> _importarModelo() async {
    final repo = Escopo.of(context).repositorio;
    if (repo == null) return;
    final modelos = await repo.listarModelos();
    if (!mounted) return;
    if (modelos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum modelo salvo neste computador.')),
      );
      return;
    }
    final escolhido = await showDialog<Modelo>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Importar modelo'),
        content: SizedBox(
          width: 420,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final modelo in modelos)
                ListTile(
                  title: Text(modelo.nome),
                  subtitle: Text(
                    perfilPorNome(modelo.perfil)?.titulo ?? 'Sem perfil',
                  ),
                  onTap: () => Navigator.pop(contexto, modelo),
                ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(contexto),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
    if (escolhido == null || !mounted) return;
    setState(() {
      for (final campo in _rotulos.values) {
        campo.dispose();
      }
      _rotulos.clear();
      _montagem = lerMontagem(escolhido.etapasJson);
      _importancia = Map<String, String>.from(_montagem.importancia);
      _tempos = Map<String, int>.from(_montagem.tempos);
      _etapasJson = escolhido.etapasJson;
      _perfil = perfilPorNome(escolhido.perfil)?.id ?? _perfil;
      _sincronizarOrdem();
    });
    await _salvar(concluir: false);
  }

  List<Widget> _botoesNovos() {
    return [
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: () => _adicionar('texto'),
            icon: const Icon(Icons.notes),
            label: const Text('Caixa de pergunta'),
          ),
          FilledButton.icon(
            onPressed: () => _adicionar('campo'),
            icon: const Icon(Icons.short_text),
            label: const Text('Campo de resposta'),
          ),
        ],
      ),
    ];
  }

  void _adicionar(String tipo) {
    final etapa = _etapaDoPasso();
    if (etapa == null) return;
    final id = 'extra.${novoId()}';
    final texto = tipo == 'campo' ? 'Nova pergunta' : 'Nova caixa de pergunta';
    setState(() {
      _montagem = Montagem(
        textos: _montagem.textos,
        extras: [
          ..._montagem.extras,
          ExtraBloco(id: id, etapa: etapa, tipo: tipo, texto: texto),
        ],
        ordem: _ordem,
      );
      _ordem = {
        for (final nome in etapasMontagem)
          nome: List<String>.from(_ordem[nome] ?? const <String>[]),
      };
      _ordem[etapa]!.add(id);
      _rotulo(id, texto);
    });
  }

  void _mover(String etapa, int indice, int direcao) {
    setState(() {
      _ordem = moverBloco(_ordem, etapa, indice, direcao);
      _alinharExtras();
    });
  }

  void _remover(String id) {
    setState(() {
      _montagem = Montagem(
        textos: _montagem.textos,
        extras: [
          for (final extra in _montagem.extras)
            if (extra.id != id) extra,
        ],
        ordem: _ordem,
      );
      _ordem = {
        for (final nome in etapasMontagem)
          nome: [
            for (final item in _ordem[nome] ?? const <String>[])
              if (item != id) item,
          ],
      };
      _rotulos.remove(id)?.dispose();
      _campos.remove(id)?.dispose();
      _importancia.remove(id);
    });
  }

  void _alinharExtras() {
    final porId = {for (final extra in _montagem.extras) extra.id: extra};
    final atualizados = <ExtraBloco>[];
    for (final etapa in etapasMontagem) {
      for (final id in _ordem[etapa] ?? const <String>[]) {
        final extra = porId[id];
        if (extra == null) continue;
        atualizados.add(
          ExtraBloco(
            id: extra.id,
            etapa: etapa,
            tipo: extra.tipo,
            texto: _rotulos[extra.id]?.text ?? extra.texto,
          ),
        );
      }
    }
    _montagem = Montagem(
      textos: _montagem.textos,
      extras: atualizados,
      ordem: _ordem,
    );
  }

  Montagem _coletarMontagem() {
    final perfil = _perfil == null ? null : perfilPorId(_perfil!);
    final textos = Map<String, String>.from(_montagem.textos);
    for (final etapa in etapasMontagem) {
      for (final id in _ordem[etapa] ?? const <String>[]) {
        if (id.startsWith(prefixoCampo) || id.startsWith('extra.')) continue;
        final padrao = textoPadraoBloco(id, perfil);
        final campo = _rotulos[id];
        if (padrao == null || campo == null) continue;
        final valor = textoDeFala(id)
            ? restaurarMarcadorNome(campo.text, _nomeCliente)
            : campo.text;
        final seguinte = definirEtapa(textos, id, valor, padrao);
        textos
          ..clear()
          ..addAll(seguinte);
      }
    }
    final extras = <ExtraBloco>[];
    for (final etapa in etapasMontagem) {
      for (final id in _ordem[etapa] ?? const <String>[]) {
        ExtraBloco? extra;
        for (final item in _montagem.extras) {
          if (item.id == id) extra = item;
        }
        if (extra == null) continue;
        extras.add(
          ExtraBloco(
            id: extra.id,
            etapa: etapa,
            tipo: extra.tipo,
            texto: (_rotulos[extra.id]?.text ?? extra.texto).trim(),
          ),
        );
      }
    }
    return Montagem(
      textos: textos,
      extras: extras,
      ordem: _ordem,
      importancia: {
        for (final entrada in _importancia.entries)
          if (entrada.value == importanciaAlta ||
              entrada.value == importanciaMedia ||
              entrada.value == importanciaBaixa)
            entrada.key: entrada.value,
      },
      tempos: Map<String, int>.from(_tempos),
    );
  }

  Widget _relogioEtapa() {
    final decorrido = _decorridos[_passo];
    final estourou = tempoAcimaDaMeta(decorrido, _minutosDoPasso());
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Text(
            formatarDuracao(decorrido),
            style: TextStyle(
              fontSize: 28,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: estourou ? erro : carvao,
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: _alternarRelogio,
            child: Text(_correndo[_passo] ? 'Pausar' : 'Iniciar tempo'),
          ),
        ],
      ),
    );
  }

  String _semDuracao(String texto) {
    final limpo = texto
        .replaceFirst(RegExp(r'^Cerca de .+?minutos\.\s*'), '')
        .trim();
    return limpo.isEmpty ? texto.trim() : limpo;
  }

  Widget _caixa(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: carvao,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: textoNoEscuro,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

final _estiloNaBarra = OutlinedButton.styleFrom(
  foregroundColor: carvao,
  backgroundColor: menta,
  side: const BorderSide(color: menta),
  shape: const StadiumBorder(),
);

class _CardPerfil extends StatelessWidget {
  const _CardPerfil({
    required this.perfil,
    required this.selecionado,
    required this.sugerido,
    required this.aoTocar,
  });

  final PerfilRoteiro perfil;
  final bool selecionado;
  final bool sugerido;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final cor = selecionado ? menta : verde;
    return InkWell(
      onTap: aoTocar,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado || sugerido ? cor : bege,
            width: selecionado ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              perfil.titulo,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (sugerido)
              const Text(
                'Sugestão',
                style: TextStyle(
                  color: verde,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 6),
            Text(perfil.sinais, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
