/*
5. Deve ser feita a persistência com SQLite: crie um arquivo que gerencia as transações com o
banco, faça a classe de modelo ter um factory fromMap e um método toMap para facilitar
acesso ao banco de dados. Utilize id auto gerado pelo banco. Lembre-se que a data deve ser
armazenada como Text, pesquise como você pode fazer essa transformação.
*/
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DB {
  static Future<sqlite.Database> getDatabase() async {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      sqlite.databaseFactory = databaseFactoryFfi;
    }

    final databasePath = await sqlite
        .getDatabasesPath(); //salva o caminho para o diretório do bd
    final dbPath = path.join(
      databasePath,
      'tarefas.db',
    ); //cria o caminho completo para o bd

    //abre o banco de dados, se não existir ele é criado
    return await sqlite.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tarefas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descricao TEXT,
            responsavel TEXT,
            dataPrevista TEXT,
            importante INTEGER,
            realizada INTEGER
          )
        ''');
      },
    );
  }

  //CRUD
  static Future<void> create(Map<String, dynamic> tarefa) async {
    final db = await getDatabase();
    await db.insert('tarefas', tarefa);
  }

  static Future<List<Map<String, dynamic>>> read(String busca) async {
    final db = await getDatabase();
    return await db.query(
      'tarefas',
      where: 'titulo LIKE ?',
      whereArgs: ['%$busca%'],
    );
  }

  static Future<void> update(int id, Map<String, dynamic> tarefa) async {
    final db = await getDatabase();
    final tarefaData = Map<String, dynamic>.from(tarefa);
    tarefaData.remove('id');
    await db.update('tarefas', tarefaData, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> delete(int id) async {
    final db = await getDatabase();
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
