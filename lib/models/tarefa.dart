/* Tarefa 
ada tarefa deve ter no mínimo os seguintes atributos: 
id, título, descrição, data prevista para realização, importante (boolean), realizada(boolean).

Requisitos e item que serão avaliados:
1. Crie um atributo a mais para a sua tarefa (de escolha de cada estudante).
*/
import 'package:ifsc_mobile_av1_crud/models/model.dart';

class Tarefa implements Model {
  int? _id;
  String titulo;
  String descricao;
  String responsavel;//extra
  DateTime dataPrevista;
  bool importante;
  bool realizada;

  Tarefa({
    required this.titulo,
    required this.descricao,
    required this.responsavel,
    required this.dataPrevista,
    required this.importante,
    required this.realizada
  });

  @override
  set id(int id) {
    _id = id;
  }

  @override
  int? get id => _id;

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    var tarefa = Tarefa(
      titulo: map['titulo'],
      descricao: map['descricao'],
      responsavel: map['responsavel'],
      dataPrevista: DateTime.parse(map['dataPrevista']),
      importante: map['importante'] == 1,
      realizada: map['realizada'] == 1
    );
    tarefa.id = map['id'];
    return tarefa;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'titulo': titulo,
      'descricao': descricao,
      'responsavel': responsavel,
      'dataPrevista': dataPrevista.toIso8601String(),
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0
    };
  }

  @override
  String toString() {
    return 'Tarefa{id: $_id, titulo: $titulo, descricao: $descricao, responsavel: $responsavel, dataPrevista: $dataPrevista, importante: $importante, realizada: $realizada}';
  }
}