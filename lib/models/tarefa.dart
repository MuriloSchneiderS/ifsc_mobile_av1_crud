/* Tarefa 
ada tarefa deve ter no mínimo os seguintes atributos: 
id, título, descrição, data prevista para realização, importante (boolean), realizada(boolean).

Requisitos e item que serão avaliados:
1. Crie um atributo a mais para a sua tarefa (de escolha de cada estudante).
*/
class Tarefa {
  int? id;
  String titulo;
  String descricao;
  String responsavel;//extra
  DateTime dataPrevista;
  bool importante;
  bool realizada;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.responsavel,
    required this.dataPrevista,
    required this.importante,
    required this.realizada
  });

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      responsavel: map['responsavel'],
      dataPrevista: DateTime.parse(map['dataPrevista']),
      importante: map['importante'] == 1,
      realizada: map['realizada'] == 1
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'responsavel': responsavel,
      'dataPrevista': dataPrevista.toIso8601String(),
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0
    };
  }
}