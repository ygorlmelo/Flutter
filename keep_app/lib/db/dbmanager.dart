import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbListaTarefas {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "ss.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE tarefa(id INTEGER PRIMARY KEY autoincrement, descricao TEXT)",
        );
      });
    }
  }

  Future<int> inserirTarefa(Tarefa tarefa) async {
    await openDb();
    return await _database.insert('tarefa', tarefa.toMap());
  }

  Future<List<Tarefa>> getTarefaList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('tarefa');
    return List.generate(maps.length, (i) {
      return Tarefa(
          id: maps[i]['id'], descricao: maps[i]['descricao']);
    });
  }

  Future<int> atualizarTarefa(Tarefa tarefa) async {
    await openDb();
    return await _database.update('tarefa', tarefa.toMap(),
        where: "id = ?", whereArgs: [tarefa.id]);
  }

  Future<void> deletarTarefa(int id) async {
    await openDb();
    await _database.delete(
        'tarefa',
          where: "id = ?", whereArgs: [id]
    );
  }
}

class Tarefa{
  int id;
  String descricao;

  Tarefa({@required this.descricao, this.id});
  Map<String, dynamic> toMap(){
    return{'descricao': descricao};
  }
}