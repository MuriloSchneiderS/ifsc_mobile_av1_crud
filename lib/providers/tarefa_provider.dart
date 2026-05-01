/*
ada tarefa deve ter no mínimo os seguintes atributos: 
id, título, descrição, data prevista para realização, importante (boolean), realizada(boolean).

Requisitos e item que serão avaliados:
1. Crie um atributo a mais para a sua tarefa (de escolha de cada estudante).
[...]
6. Deve ser feito gerenciamento de estado com o Provider (não precisa ser todas informações
gerenciadas com o Provider, mas a que se demonstrarem mais relevantes).
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/util/db.dart';
import 'package:ifsc_mobile_av1_crud/models/tarefa.dart';

class TarefaProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];//lista de tarefas gerenciada pelo provider
  List<Tarefa> get tarefas => _tarefas;//getter que acessa a lista de tarefas

  //CRUD (utilizando os métodos do DBUtil -> util.db.dart)
  Future<void> addTarefa(Tarefa tarefa) async {
    await DBUtil.create(tarefa.toMap());
    await loadTarefas();
  }
  Future<void> loadTarefas() async {
    final tarefasRetornadas = await DBUtil.read('');
    _tarefas = tarefasRetornadas.map((item) => Tarefa.fromMap(item)).toList();
    notifyListeners();
  }
  Future<void> updateTarefa(int id, Tarefa tarefa) async {
    await DBUtil.update(id, tarefa.toMap());
    await loadTarefas();
  }
  Future<void> deleteTarefa(int id) async {
    await DBUtil.delete(id);
    await loadTarefas();
  }
}