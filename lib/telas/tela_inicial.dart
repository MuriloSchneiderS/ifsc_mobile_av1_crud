/*
7. Utilização de navegação com rotas nomeadas. Faça uma tela inicial de boas vindas que
mostra o título e data prevista da tarefa mais perto de ser vencida.
*/
import 'package:flutter/material.dart';

class tela_inicial extends StatelessWidget {
  final String titulo;
  const tela_inicial({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Center(
        child: Text('App de Tarefas!'),
      ),
    );
  }
}