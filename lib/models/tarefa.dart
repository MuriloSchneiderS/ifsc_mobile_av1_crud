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
    required this.realizada,
  });

  @override
  set id(int id) {
    _id = id;
  }

  @override
  int? get id => _id;

  factory Tarefa.fromMap(Map<String, dynamic> map) {//converte um mapa do banco de dados para um objeto Tarefa
    var tarefa = Tarefa(
      titulo: map['titulo'],
      descricao: map['descricao'],
      responsavel: map['responsavel'],
      dataPrevista: DateTime.parse(map['dataPrevista']),
      importante: map['importante'] == 1,
      realizada: map['realizada'] == 1,
    );
    tarefa.id = map['id'];
    return tarefa;
  }

  @override
  Map<String, dynamic> toMap() {//converte um objeto Tarefa para um mapa que pode ser salvo no banco de dados
    final map = <String, dynamic>{
      'titulo': titulo,
      'descricao': descricao,
      'responsavel': responsavel,
      'dataPrevista': dataPrevista.toIso8601String(),//converte a data para string no formato padrão para datas
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0,
    };
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  String get dataFormatada {//formata a data prevista para o formato dd/MM/yyyy HH:mm
    final dia = dataPrevista.day.toString().padLeft(2, '0');
    final mes = dataPrevista.month.toString().padLeft(2, '0');
    final ano = dataPrevista.year;
    final hora = dataPrevista.hour.toString().padLeft(2, '0');
    final minuto = dataPrevista.minute.toString().padLeft(2, '0');
    
    return '$dia/$mes/$ano $hora:$minuto';
  }

  @override
  String toString() {
    return 'Tarefa{id: $_id, titulo: $titulo, descricao: $descricao, responsavel: $responsavel, dataPrevista: $dataPrevista, importante: $importante, realizada: $realizada}';
  }
}
