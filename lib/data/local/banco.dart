import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'banco.g.dart';

class Clientes extends Table {
  TextColumn get id => text()();

  TextColumn get ownerUid => text()();

  TextColumn get nome => text()();

  TextColumn get telefone => text().withDefault(const Constant(''))();

  TextColumn get email => text().withDefault(const Constant(''))();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Reuniao')
class Reunioes extends Table {
  TextColumn get id => text()();

  TextColumn get clienteId => text()();

  TextColumn get ownerUid => text()();

  TextColumn get perfil => text().nullable()();

  TextColumn get expectativa => text().withDefault(const Constant(''))();

  TextColumn get respostasJson => text().withDefault(const Constant('{}'))();

  TextColumn get notasPlano => text().withDefault(const Constant(''))();

  TextColumn get notasProposta => text().withDefault(const Constant(''))();

  TextColumn get status => text().withDefault(const Constant('rascunho'))();

  TextColumn get etapasJson => text().withDefault(const Constant('{}'))();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Exclusao')
class Exclusoes extends Table {
  TextColumn get id => text()();

  TextColumn get ownerUid => text()();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Modelo')
class Modelos extends Table {
  TextColumn get id => text()();

  TextColumn get ownerUid => text()();

  TextColumn get nome => text()();

  TextColumn get perfil => text().nullable()();

  TextColumn get etapasJson => text().withDefault(const Constant('{}'))();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Ajuste')
class Ajustes extends Table {
  TextColumn get ownerUid => text()();

  TextColumn get json => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {ownerUid};
}

@DriftDatabase(tables: [Clientes, Reunioes, Modelos, Exclusoes, Ajustes])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.memoria() : super(NativeDatabase.memory());

  AppDatabase.padrao() : super(driftDatabase(name: 'marco_zero'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(reunioes, reunioes.etapasJson);
      }
      if (from < 3) {
        await migrator.createTable(modelos);
      }
      if (from < 4) {
        await migrator.createTable(exclusoes);
      }
      if (from < 5) {
        await migrator.createTable(ajustes);
      }
    },
  );
}
