// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banco.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefoneMeta = const VerificationMeta(
    'telefone',
  );
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
    'telefone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUid,
    nome,
    telefone,
    email,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('telefone')) {
      context.handle(
        _telefoneMeta,
        telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      telefone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final String id;
  final String ownerUid;
  final String nome;
  final String telefone;
  final String email;
  final int updatedAt;
  const Cliente({
    required this.id,
    required this.ownerUid,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['nome'] = Variable<String>(nome);
    map['telefone'] = Variable<String>(telefone);
    map['email'] = Variable<String>(email);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      nome: Value(nome),
      telefone: Value(telefone),
      email: Value(email),
      updatedAt: Value(updatedAt),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<String>(json['id']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      nome: serializer.fromJson<String>(json['nome']),
      telefone: serializer.fromJson<String>(json['telefone']),
      email: serializer.fromJson<String>(json['email']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'nome': serializer.toJson<String>(nome),
      'telefone': serializer.toJson<String>(telefone),
      'email': serializer.toJson<String>(email),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Cliente copyWith({
    String? id,
    String? ownerUid,
    String? nome,
    String? telefone,
    String? email,
    int? updatedAt,
  }) => Cliente(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    nome: nome ?? this.nome,
    telefone: telefone ?? this.telefone,
    email: email ?? this.email,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      nome: data.nome.present ? data.nome.value : this.nome,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
      email: data.email.present ? data.email.value : this.email,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('email: $email, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerUid, nome, telefone, email, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.nome == this.nome &&
          other.telefone == this.telefone &&
          other.email == this.email &&
          other.updatedAt == this.updatedAt);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<String> id;
  final Value<String> ownerUid;
  final Value<String> nome;
  final Value<String> telefone;
  final Value<String> email;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.nome = const Value.absent(),
    this.telefone = const Value.absent(),
    this.email = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String ownerUid,
    required String nome,
    this.telefone = const Value.absent(),
    this.email = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUid = Value(ownerUid),
       nome = Value(nome),
       updatedAt = Value(updatedAt);
  static Insertable<Cliente> custom({
    Expression<String>? id,
    Expression<String>? ownerUid,
    Expression<String>? nome,
    Expression<String>? telefone,
    Expression<String>? email,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (nome != null) 'nome': nome,
      if (telefone != null) 'telefone': telefone,
      if (email != null) 'email': email,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUid,
    Value<String>? nome,
    Value<String>? telefone,
    Value<String>? email,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('email: $email, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReunioesTable extends Reunioes with TableInfo<$ReunioesTable, Reuniao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReunioesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _perfilMeta = const VerificationMeta('perfil');
  @override
  late final GeneratedColumn<String> perfil = GeneratedColumn<String>(
    'perfil',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectativaMeta = const VerificationMeta(
    'expectativa',
  );
  @override
  late final GeneratedColumn<String> expectativa = GeneratedColumn<String>(
    'expectativa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _respostasJsonMeta = const VerificationMeta(
    'respostasJson',
  );
  @override
  late final GeneratedColumn<String> respostasJson = GeneratedColumn<String>(
    'respostas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _notasPlanoMeta = const VerificationMeta(
    'notasPlano',
  );
  @override
  late final GeneratedColumn<String> notasPlano = GeneratedColumn<String>(
    'notas_plano',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notasPropostaMeta = const VerificationMeta(
    'notasProposta',
  );
  @override
  late final GeneratedColumn<String> notasProposta = GeneratedColumn<String>(
    'notas_proposta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('rascunho'),
  );
  static const VerificationMeta _etapasJsonMeta = const VerificationMeta(
    'etapasJson',
  );
  @override
  late final GeneratedColumn<String> etapasJson = GeneratedColumn<String>(
    'etapas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    ownerUid,
    perfil,
    expectativa,
    respostasJson,
    notasPlano,
    notasProposta,
    status,
    etapasJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reunioes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reuniao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('perfil')) {
      context.handle(
        _perfilMeta,
        perfil.isAcceptableOrUnknown(data['perfil']!, _perfilMeta),
      );
    }
    if (data.containsKey('expectativa')) {
      context.handle(
        _expectativaMeta,
        expectativa.isAcceptableOrUnknown(
          data['expectativa']!,
          _expectativaMeta,
        ),
      );
    }
    if (data.containsKey('respostas_json')) {
      context.handle(
        _respostasJsonMeta,
        respostasJson.isAcceptableOrUnknown(
          data['respostas_json']!,
          _respostasJsonMeta,
        ),
      );
    }
    if (data.containsKey('notas_plano')) {
      context.handle(
        _notasPlanoMeta,
        notasPlano.isAcceptableOrUnknown(data['notas_plano']!, _notasPlanoMeta),
      );
    }
    if (data.containsKey('notas_proposta')) {
      context.handle(
        _notasPropostaMeta,
        notasProposta.isAcceptableOrUnknown(
          data['notas_proposta']!,
          _notasPropostaMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('etapas_json')) {
      context.handle(
        _etapasJsonMeta,
        etapasJson.isAcceptableOrUnknown(data['etapas_json']!, _etapasJsonMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reuniao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reuniao(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      perfil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}perfil'],
      ),
      expectativa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expectativa'],
      )!,
      respostasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}respostas_json'],
      )!,
      notasPlano: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas_plano'],
      )!,
      notasProposta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas_proposta'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      etapasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etapas_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReunioesTable createAlias(String alias) {
    return $ReunioesTable(attachedDatabase, alias);
  }
}

class Reuniao extends DataClass implements Insertable<Reuniao> {
  final String id;
  final String clienteId;
  final String ownerUid;
  final String? perfil;
  final String expectativa;
  final String respostasJson;
  final String notasPlano;
  final String notasProposta;
  final String status;
  final String etapasJson;
  final int updatedAt;
  const Reuniao({
    required this.id,
    required this.clienteId,
    required this.ownerUid,
    this.perfil,
    required this.expectativa,
    required this.respostasJson,
    required this.notasPlano,
    required this.notasProposta,
    required this.status,
    required this.etapasJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    map['owner_uid'] = Variable<String>(ownerUid);
    if (!nullToAbsent || perfil != null) {
      map['perfil'] = Variable<String>(perfil);
    }
    map['expectativa'] = Variable<String>(expectativa);
    map['respostas_json'] = Variable<String>(respostasJson);
    map['notas_plano'] = Variable<String>(notasPlano);
    map['notas_proposta'] = Variable<String>(notasProposta);
    map['status'] = Variable<String>(status);
    map['etapas_json'] = Variable<String>(etapasJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReunioesCompanion toCompanion(bool nullToAbsent) {
    return ReunioesCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      ownerUid: Value(ownerUid),
      perfil: perfil == null && nullToAbsent
          ? const Value.absent()
          : Value(perfil),
      expectativa: Value(expectativa),
      respostasJson: Value(respostasJson),
      notasPlano: Value(notasPlano),
      notasProposta: Value(notasProposta),
      status: Value(status),
      etapasJson: Value(etapasJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reuniao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reuniao(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      perfil: serializer.fromJson<String?>(json['perfil']),
      expectativa: serializer.fromJson<String>(json['expectativa']),
      respostasJson: serializer.fromJson<String>(json['respostasJson']),
      notasPlano: serializer.fromJson<String>(json['notasPlano']),
      notasProposta: serializer.fromJson<String>(json['notasProposta']),
      status: serializer.fromJson<String>(json['status']),
      etapasJson: serializer.fromJson<String>(json['etapasJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'perfil': serializer.toJson<String?>(perfil),
      'expectativa': serializer.toJson<String>(expectativa),
      'respostasJson': serializer.toJson<String>(respostasJson),
      'notasPlano': serializer.toJson<String>(notasPlano),
      'notasProposta': serializer.toJson<String>(notasProposta),
      'status': serializer.toJson<String>(status),
      'etapasJson': serializer.toJson<String>(etapasJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Reuniao copyWith({
    String? id,
    String? clienteId,
    String? ownerUid,
    Value<String?> perfil = const Value.absent(),
    String? expectativa,
    String? respostasJson,
    String? notasPlano,
    String? notasProposta,
    String? status,
    String? etapasJson,
    int? updatedAt,
  }) => Reuniao(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    ownerUid: ownerUid ?? this.ownerUid,
    perfil: perfil.present ? perfil.value : this.perfil,
    expectativa: expectativa ?? this.expectativa,
    respostasJson: respostasJson ?? this.respostasJson,
    notasPlano: notasPlano ?? this.notasPlano,
    notasProposta: notasProposta ?? this.notasProposta,
    status: status ?? this.status,
    etapasJson: etapasJson ?? this.etapasJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Reuniao copyWithCompanion(ReunioesCompanion data) {
    return Reuniao(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      perfil: data.perfil.present ? data.perfil.value : this.perfil,
      expectativa: data.expectativa.present
          ? data.expectativa.value
          : this.expectativa,
      respostasJson: data.respostasJson.present
          ? data.respostasJson.value
          : this.respostasJson,
      notasPlano: data.notasPlano.present
          ? data.notasPlano.value
          : this.notasPlano,
      notasProposta: data.notasProposta.present
          ? data.notasProposta.value
          : this.notasProposta,
      status: data.status.present ? data.status.value : this.status,
      etapasJson: data.etapasJson.present
          ? data.etapasJson.value
          : this.etapasJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reuniao(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('perfil: $perfil, ')
          ..write('expectativa: $expectativa, ')
          ..write('respostasJson: $respostasJson, ')
          ..write('notasPlano: $notasPlano, ')
          ..write('notasProposta: $notasProposta, ')
          ..write('status: $status, ')
          ..write('etapasJson: $etapasJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    ownerUid,
    perfil,
    expectativa,
    respostasJson,
    notasPlano,
    notasProposta,
    status,
    etapasJson,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reuniao &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.ownerUid == this.ownerUid &&
          other.perfil == this.perfil &&
          other.expectativa == this.expectativa &&
          other.respostasJson == this.respostasJson &&
          other.notasPlano == this.notasPlano &&
          other.notasProposta == this.notasProposta &&
          other.status == this.status &&
          other.etapasJson == this.etapasJson &&
          other.updatedAt == this.updatedAt);
}

class ReunioesCompanion extends UpdateCompanion<Reuniao> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String> ownerUid;
  final Value<String?> perfil;
  final Value<String> expectativa;
  final Value<String> respostasJson;
  final Value<String> notasPlano;
  final Value<String> notasProposta;
  final Value<String> status;
  final Value<String> etapasJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ReunioesCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.perfil = const Value.absent(),
    this.expectativa = const Value.absent(),
    this.respostasJson = const Value.absent(),
    this.notasPlano = const Value.absent(),
    this.notasProposta = const Value.absent(),
    this.status = const Value.absent(),
    this.etapasJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReunioesCompanion.insert({
    required String id,
    required String clienteId,
    required String ownerUid,
    this.perfil = const Value.absent(),
    this.expectativa = const Value.absent(),
    this.respostasJson = const Value.absent(),
    this.notasPlano = const Value.absent(),
    this.notasProposta = const Value.absent(),
    this.status = const Value.absent(),
    this.etapasJson = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clienteId = Value(clienteId),
       ownerUid = Value(ownerUid),
       updatedAt = Value(updatedAt);
  static Insertable<Reuniao> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? ownerUid,
    Expression<String>? perfil,
    Expression<String>? expectativa,
    Expression<String>? respostasJson,
    Expression<String>? notasPlano,
    Expression<String>? notasProposta,
    Expression<String>? status,
    Expression<String>? etapasJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (perfil != null) 'perfil': perfil,
      if (expectativa != null) 'expectativa': expectativa,
      if (respostasJson != null) 'respostas_json': respostasJson,
      if (notasPlano != null) 'notas_plano': notasPlano,
      if (notasProposta != null) 'notas_proposta': notasProposta,
      if (status != null) 'status': status,
      if (etapasJson != null) 'etapas_json': etapasJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReunioesCompanion copyWith({
    Value<String>? id,
    Value<String>? clienteId,
    Value<String>? ownerUid,
    Value<String?>? perfil,
    Value<String>? expectativa,
    Value<String>? respostasJson,
    Value<String>? notasPlano,
    Value<String>? notasProposta,
    Value<String>? status,
    Value<String>? etapasJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReunioesCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      ownerUid: ownerUid ?? this.ownerUid,
      perfil: perfil ?? this.perfil,
      expectativa: expectativa ?? this.expectativa,
      respostasJson: respostasJson ?? this.respostasJson,
      notasPlano: notasPlano ?? this.notasPlano,
      notasProposta: notasProposta ?? this.notasProposta,
      status: status ?? this.status,
      etapasJson: etapasJson ?? this.etapasJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (perfil.present) {
      map['perfil'] = Variable<String>(perfil.value);
    }
    if (expectativa.present) {
      map['expectativa'] = Variable<String>(expectativa.value);
    }
    if (respostasJson.present) {
      map['respostas_json'] = Variable<String>(respostasJson.value);
    }
    if (notasPlano.present) {
      map['notas_plano'] = Variable<String>(notasPlano.value);
    }
    if (notasProposta.present) {
      map['notas_proposta'] = Variable<String>(notasProposta.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (etapasJson.present) {
      map['etapas_json'] = Variable<String>(etapasJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReunioesCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('perfil: $perfil, ')
          ..write('expectativa: $expectativa, ')
          ..write('respostasJson: $respostasJson, ')
          ..write('notasPlano: $notasPlano, ')
          ..write('notasProposta: $notasProposta, ')
          ..write('status: $status, ')
          ..write('etapasJson: $etapasJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelosTable extends Modelos with TableInfo<$ModelosTable, Modelo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _perfilMeta = const VerificationMeta('perfil');
  @override
  late final GeneratedColumn<String> perfil = GeneratedColumn<String>(
    'perfil',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etapasJsonMeta = const VerificationMeta(
    'etapasJson',
  );
  @override
  late final GeneratedColumn<String> etapasJson = GeneratedColumn<String>(
    'etapas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUid,
    nome,
    perfil,
    etapasJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modelos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Modelo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('perfil')) {
      context.handle(
        _perfilMeta,
        perfil.isAcceptableOrUnknown(data['perfil']!, _perfilMeta),
      );
    }
    if (data.containsKey('etapas_json')) {
      context.handle(
        _etapasJsonMeta,
        etapasJson.isAcceptableOrUnknown(data['etapas_json']!, _etapasJsonMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Modelo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Modelo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      perfil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}perfil'],
      ),
      etapasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etapas_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ModelosTable createAlias(String alias) {
    return $ModelosTable(attachedDatabase, alias);
  }
}

class Modelo extends DataClass implements Insertable<Modelo> {
  final String id;
  final String ownerUid;
  final String nome;
  final String? perfil;
  final String etapasJson;
  final int updatedAt;
  const Modelo({
    required this.id,
    required this.ownerUid,
    required this.nome,
    this.perfil,
    required this.etapasJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || perfil != null) {
      map['perfil'] = Variable<String>(perfil);
    }
    map['etapas_json'] = Variable<String>(etapasJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ModelosCompanion toCompanion(bool nullToAbsent) {
    return ModelosCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      nome: Value(nome),
      perfil: perfil == null && nullToAbsent
          ? const Value.absent()
          : Value(perfil),
      etapasJson: Value(etapasJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory Modelo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Modelo(
      id: serializer.fromJson<String>(json['id']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      nome: serializer.fromJson<String>(json['nome']),
      perfil: serializer.fromJson<String?>(json['perfil']),
      etapasJson: serializer.fromJson<String>(json['etapasJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'nome': serializer.toJson<String>(nome),
      'perfil': serializer.toJson<String?>(perfil),
      'etapasJson': serializer.toJson<String>(etapasJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Modelo copyWith({
    String? id,
    String? ownerUid,
    String? nome,
    Value<String?> perfil = const Value.absent(),
    String? etapasJson,
    int? updatedAt,
  }) => Modelo(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    nome: nome ?? this.nome,
    perfil: perfil.present ? perfil.value : this.perfil,
    etapasJson: etapasJson ?? this.etapasJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Modelo copyWithCompanion(ModelosCompanion data) {
    return Modelo(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      nome: data.nome.present ? data.nome.value : this.nome,
      perfil: data.perfil.present ? data.perfil.value : this.perfil,
      etapasJson: data.etapasJson.present
          ? data.etapasJson.value
          : this.etapasJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Modelo(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('nome: $nome, ')
          ..write('perfil: $perfil, ')
          ..write('etapasJson: $etapasJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerUid, nome, perfil, etapasJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Modelo &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.nome == this.nome &&
          other.perfil == this.perfil &&
          other.etapasJson == this.etapasJson &&
          other.updatedAt == this.updatedAt);
}

class ModelosCompanion extends UpdateCompanion<Modelo> {
  final Value<String> id;
  final Value<String> ownerUid;
  final Value<String> nome;
  final Value<String?> perfil;
  final Value<String> etapasJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ModelosCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.nome = const Value.absent(),
    this.perfil = const Value.absent(),
    this.etapasJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelosCompanion.insert({
    required String id,
    required String ownerUid,
    required String nome,
    this.perfil = const Value.absent(),
    this.etapasJson = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUid = Value(ownerUid),
       nome = Value(nome),
       updatedAt = Value(updatedAt);
  static Insertable<Modelo> custom({
    Expression<String>? id,
    Expression<String>? ownerUid,
    Expression<String>? nome,
    Expression<String>? perfil,
    Expression<String>? etapasJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (nome != null) 'nome': nome,
      if (perfil != null) 'perfil': perfil,
      if (etapasJson != null) 'etapas_json': etapasJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelosCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUid,
    Value<String>? nome,
    Value<String?>? perfil,
    Value<String>? etapasJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ModelosCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      nome: nome ?? this.nome,
      perfil: perfil ?? this.perfil,
      etapasJson: etapasJson ?? this.etapasJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (perfil.present) {
      map['perfil'] = Variable<String>(perfil.value);
    }
    if (etapasJson.present) {
      map['etapas_json'] = Variable<String>(etapasJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelosCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('nome: $nome, ')
          ..write('perfil: $perfil, ')
          ..write('etapasJson: $etapasJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExclusoesTable extends Exclusoes
    with TableInfo<$ExclusoesTable, Exclusao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExclusoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ownerUid, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exclusoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exclusao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exclusao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exclusao(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExclusoesTable createAlias(String alias) {
    return $ExclusoesTable(attachedDatabase, alias);
  }
}

class Exclusao extends DataClass implements Insertable<Exclusao> {
  final String id;
  final String ownerUid;
  final int updatedAt;
  const Exclusao({
    required this.id,
    required this.ownerUid,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ExclusoesCompanion toCompanion(bool nullToAbsent) {
    return ExclusoesCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      updatedAt: Value(updatedAt),
    );
  }

  factory Exclusao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exclusao(
      id: serializer.fromJson<String>(json['id']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Exclusao copyWith({String? id, String? ownerUid, int? updatedAt}) => Exclusao(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Exclusao copyWithCompanion(ExclusoesCompanion data) {
    return Exclusao(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exclusao(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerUid, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exclusao &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.updatedAt == this.updatedAt);
}

class ExclusoesCompanion extends UpdateCompanion<Exclusao> {
  final Value<String> id;
  final Value<String> ownerUid;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ExclusoesCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExclusoesCompanion.insert({
    required String id,
    required String ownerUid,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUid = Value(ownerUid),
       updatedAt = Value(updatedAt);
  static Insertable<Exclusao> custom({
    Expression<String>? id,
    Expression<String>? ownerUid,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExclusoesCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUid,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExclusoesCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExclusoesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AjustesTable extends Ajustes with TableInfo<$AjustesTable, Ajuste> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AjustesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [ownerUid, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ajustes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ajuste> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownerUid};
  @override
  Ajuste map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ajuste(
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $AjustesTable createAlias(String alias) {
    return $AjustesTable(attachedDatabase, alias);
  }
}

class Ajuste extends DataClass implements Insertable<Ajuste> {
  final String ownerUid;
  final String json;
  const Ajuste({required this.ownerUid, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_uid'] = Variable<String>(ownerUid);
    map['json'] = Variable<String>(json);
    return map;
  }

  AjustesCompanion toCompanion(bool nullToAbsent) {
    return AjustesCompanion(ownerUid: Value(ownerUid), json: Value(json));
  }

  factory Ajuste.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ajuste(
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ownerUid': serializer.toJson<String>(ownerUid),
      'json': serializer.toJson<String>(json),
    };
  }

  Ajuste copyWith({String? ownerUid, String? json}) =>
      Ajuste(ownerUid: ownerUid ?? this.ownerUid, json: json ?? this.json);
  Ajuste copyWithCompanion(AjustesCompanion data) {
    return Ajuste(
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ajuste(')
          ..write('ownerUid: $ownerUid, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ownerUid, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ajuste &&
          other.ownerUid == this.ownerUid &&
          other.json == this.json);
}

class AjustesCompanion extends UpdateCompanion<Ajuste> {
  final Value<String> ownerUid;
  final Value<String> json;
  final Value<int> rowid;
  const AjustesCompanion({
    this.ownerUid = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AjustesCompanion.insert({
    required String ownerUid,
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerUid = Value(ownerUid);
  static Insertable<Ajuste> custom({
    Expression<String>? ownerUid,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AjustesCompanion copyWith({
    Value<String>? ownerUid,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return AjustesCompanion(
      ownerUid: ownerUid ?? this.ownerUid,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AjustesCompanion(')
          ..write('ownerUid: $ownerUid, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ReunioesTable reunioes = $ReunioesTable(this);
  late final $ModelosTable modelos = $ModelosTable(this);
  late final $ExclusoesTable exclusoes = $ExclusoesTable(this);
  late final $AjustesTable ajustes = $AjustesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    reunioes,
    modelos,
    exclusoes,
    ajustes,
  ];
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      required String id,
      required String ownerUid,
      required String nome,
      Value<String> telefone,
      Value<String> email,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<String> id,
      Value<String> ownerUid,
      Value<String> nome,
      Value<String> telefone,
      Value<String> email,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefone => $composableBuilder(
    column: $table.telefone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefone => $composableBuilder(
    column: $table.telefone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
          Cliente,
          PrefetchHooks Function()
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> telefone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                ownerUid: ownerUid,
                nome: nome,
                telefone: telefone,
                email: email,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUid,
                required String nome,
                Value<String> telefone = const Value.absent(),
                Value<String> email = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                nome: nome,
                telefone: telefone,
                email: email,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
      Cliente,
      PrefetchHooks Function()
    >;
typedef $$ReunioesTableCreateCompanionBuilder =
    ReunioesCompanion Function({
      required String id,
      required String clienteId,
      required String ownerUid,
      Value<String?> perfil,
      Value<String> expectativa,
      Value<String> respostasJson,
      Value<String> notasPlano,
      Value<String> notasProposta,
      Value<String> status,
      Value<String> etapasJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ReunioesTableUpdateCompanionBuilder =
    ReunioesCompanion Function({
      Value<String> id,
      Value<String> clienteId,
      Value<String> ownerUid,
      Value<String?> perfil,
      Value<String> expectativa,
      Value<String> respostasJson,
      Value<String> notasPlano,
      Value<String> notasProposta,
      Value<String> status,
      Value<String> etapasJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ReunioesTableFilterComposer
    extends Composer<_$AppDatabase, $ReunioesTable> {
  $$ReunioesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectativa => $composableBuilder(
    column: $table.expectativa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get respostasJson => $composableBuilder(
    column: $table.respostasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notasPlano => $composableBuilder(
    column: $table.notasPlano,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notasProposta => $composableBuilder(
    column: $table.notasProposta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etapasJson => $composableBuilder(
    column: $table.etapasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReunioesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReunioesTable> {
  $$ReunioesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectativa => $composableBuilder(
    column: $table.expectativa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get respostasJson => $composableBuilder(
    column: $table.respostasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notasPlano => $composableBuilder(
    column: $table.notasPlano,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notasProposta => $composableBuilder(
    column: $table.notasProposta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etapasJson => $composableBuilder(
    column: $table.etapasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReunioesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReunioesTable> {
  $$ReunioesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<String> get perfil =>
      $composableBuilder(column: $table.perfil, builder: (column) => column);

  GeneratedColumn<String> get expectativa => $composableBuilder(
    column: $table.expectativa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get respostasJson => $composableBuilder(
    column: $table.respostasJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notasPlano => $composableBuilder(
    column: $table.notasPlano,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notasProposta => $composableBuilder(
    column: $table.notasProposta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get etapasJson => $composableBuilder(
    column: $table.etapasJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReunioesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReunioesTable,
          Reuniao,
          $$ReunioesTableFilterComposer,
          $$ReunioesTableOrderingComposer,
          $$ReunioesTableAnnotationComposer,
          $$ReunioesTableCreateCompanionBuilder,
          $$ReunioesTableUpdateCompanionBuilder,
          (Reuniao, BaseReferences<_$AppDatabase, $ReunioesTable, Reuniao>),
          Reuniao,
          PrefetchHooks Function()
        > {
  $$ReunioesTableTableManager(_$AppDatabase db, $ReunioesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReunioesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReunioesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReunioesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<String?> perfil = const Value.absent(),
                Value<String> expectativa = const Value.absent(),
                Value<String> respostasJson = const Value.absent(),
                Value<String> notasPlano = const Value.absent(),
                Value<String> notasProposta = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> etapasJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReunioesCompanion(
                id: id,
                clienteId: clienteId,
                ownerUid: ownerUid,
                perfil: perfil,
                expectativa: expectativa,
                respostasJson: respostasJson,
                notasPlano: notasPlano,
                notasProposta: notasProposta,
                status: status,
                etapasJson: etapasJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clienteId,
                required String ownerUid,
                Value<String?> perfil = const Value.absent(),
                Value<String> expectativa = const Value.absent(),
                Value<String> respostasJson = const Value.absent(),
                Value<String> notasPlano = const Value.absent(),
                Value<String> notasProposta = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> etapasJson = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReunioesCompanion.insert(
                id: id,
                clienteId: clienteId,
                ownerUid: ownerUid,
                perfil: perfil,
                expectativa: expectativa,
                respostasJson: respostasJson,
                notasPlano: notasPlano,
                notasProposta: notasProposta,
                status: status,
                etapasJson: etapasJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReunioesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReunioesTable,
      Reuniao,
      $$ReunioesTableFilterComposer,
      $$ReunioesTableOrderingComposer,
      $$ReunioesTableAnnotationComposer,
      $$ReunioesTableCreateCompanionBuilder,
      $$ReunioesTableUpdateCompanionBuilder,
      (Reuniao, BaseReferences<_$AppDatabase, $ReunioesTable, Reuniao>),
      Reuniao,
      PrefetchHooks Function()
    >;
typedef $$ModelosTableCreateCompanionBuilder =
    ModelosCompanion Function({
      required String id,
      required String ownerUid,
      required String nome,
      Value<String?> perfil,
      Value<String> etapasJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ModelosTableUpdateCompanionBuilder =
    ModelosCompanion Function({
      Value<String> id,
      Value<String> ownerUid,
      Value<String> nome,
      Value<String?> perfil,
      Value<String> etapasJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ModelosTableFilterComposer
    extends Composer<_$AppDatabase, $ModelosTable> {
  $$ModelosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etapasJson => $composableBuilder(
    column: $table.etapasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModelosTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelosTable> {
  $$ModelosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etapasJson => $composableBuilder(
    column: $table.etapasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelosTable> {
  $$ModelosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get perfil =>
      $composableBuilder(column: $table.perfil, builder: (column) => column);

  GeneratedColumn<String> get etapasJson => $composableBuilder(
    column: $table.etapasJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ModelosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelosTable,
          Modelo,
          $$ModelosTableFilterComposer,
          $$ModelosTableOrderingComposer,
          $$ModelosTableAnnotationComposer,
          $$ModelosTableCreateCompanionBuilder,
          $$ModelosTableUpdateCompanionBuilder,
          (Modelo, BaseReferences<_$AppDatabase, $ModelosTable, Modelo>),
          Modelo,
          PrefetchHooks Function()
        > {
  $$ModelosTableTableManager(_$AppDatabase db, $ModelosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> perfil = const Value.absent(),
                Value<String> etapasJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelosCompanion(
                id: id,
                ownerUid: ownerUid,
                nome: nome,
                perfil: perfil,
                etapasJson: etapasJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUid,
                required String nome,
                Value<String?> perfil = const Value.absent(),
                Value<String> etapasJson = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ModelosCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                nome: nome,
                perfil: perfil,
                etapasJson: etapasJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModelosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelosTable,
      Modelo,
      $$ModelosTableFilterComposer,
      $$ModelosTableOrderingComposer,
      $$ModelosTableAnnotationComposer,
      $$ModelosTableCreateCompanionBuilder,
      $$ModelosTableUpdateCompanionBuilder,
      (Modelo, BaseReferences<_$AppDatabase, $ModelosTable, Modelo>),
      Modelo,
      PrefetchHooks Function()
    >;
typedef $$ExclusoesTableCreateCompanionBuilder =
    ExclusoesCompanion Function({
      required String id,
      required String ownerUid,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ExclusoesTableUpdateCompanionBuilder =
    ExclusoesCompanion Function({
      Value<String> id,
      Value<String> ownerUid,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ExclusoesTableFilterComposer
    extends Composer<_$AppDatabase, $ExclusoesTable> {
  $$ExclusoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExclusoesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExclusoesTable> {
  $$ExclusoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExclusoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExclusoesTable> {
  $$ExclusoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExclusoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExclusoesTable,
          Exclusao,
          $$ExclusoesTableFilterComposer,
          $$ExclusoesTableOrderingComposer,
          $$ExclusoesTableAnnotationComposer,
          $$ExclusoesTableCreateCompanionBuilder,
          $$ExclusoesTableUpdateCompanionBuilder,
          (Exclusao, BaseReferences<_$AppDatabase, $ExclusoesTable, Exclusao>),
          Exclusao,
          PrefetchHooks Function()
        > {
  $$ExclusoesTableTableManager(_$AppDatabase db, $ExclusoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExclusoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExclusoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExclusoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExclusoesCompanion(
                id: id,
                ownerUid: ownerUid,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUid,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExclusoesCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExclusoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExclusoesTable,
      Exclusao,
      $$ExclusoesTableFilterComposer,
      $$ExclusoesTableOrderingComposer,
      $$ExclusoesTableAnnotationComposer,
      $$ExclusoesTableCreateCompanionBuilder,
      $$ExclusoesTableUpdateCompanionBuilder,
      (Exclusao, BaseReferences<_$AppDatabase, $ExclusoesTable, Exclusao>),
      Exclusao,
      PrefetchHooks Function()
    >;
typedef $$AjustesTableCreateCompanionBuilder =
    AjustesCompanion Function({
      required String ownerUid,
      Value<String> json,
      Value<int> rowid,
    });
typedef $$AjustesTableUpdateCompanionBuilder =
    AjustesCompanion Function({
      Value<String> ownerUid,
      Value<String> json,
      Value<int> rowid,
    });

class $$AjustesTableFilterComposer
    extends Composer<_$AppDatabase, $AjustesTable> {
  $$AjustesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AjustesTableOrderingComposer
    extends Composer<_$AppDatabase, $AjustesTable> {
  $$AjustesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AjustesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AjustesTable> {
  $$AjustesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$AjustesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AjustesTable,
          Ajuste,
          $$AjustesTableFilterComposer,
          $$AjustesTableOrderingComposer,
          $$AjustesTableAnnotationComposer,
          $$AjustesTableCreateCompanionBuilder,
          $$AjustesTableUpdateCompanionBuilder,
          (Ajuste, BaseReferences<_$AppDatabase, $AjustesTable, Ajuste>),
          Ajuste,
          PrefetchHooks Function()
        > {
  $$AjustesTableTableManager(_$AppDatabase db, $AjustesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AjustesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AjustesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AjustesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> ownerUid = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AjustesCompanion(
                ownerUid: ownerUid,
                json: json,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ownerUid,
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AjustesCompanion.insert(
                ownerUid: ownerUid,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AjustesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AjustesTable,
      Ajuste,
      $$AjustesTableFilterComposer,
      $$AjustesTableOrderingComposer,
      $$AjustesTableAnnotationComposer,
      $$AjustesTableCreateCompanionBuilder,
      $$AjustesTableUpdateCompanionBuilder,
      (Ajuste, BaseReferences<_$AppDatabase, $AjustesTable, Ajuste>),
      Ajuste,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ReunioesTableTableManager get reunioes =>
      $$ReunioesTableTableManager(_db, _db.reunioes);
  $$ModelosTableTableManager get modelos =>
      $$ModelosTableTableManager(_db, _db.modelos);
  $$ExclusoesTableTableManager get exclusoes =>
      $$ExclusoesTableTableManager(_db, _db.exclusoes);
  $$AjustesTableTableManager get ajustes =>
      $$AjustesTableTableManager(_db, _db.ajustes);
}
