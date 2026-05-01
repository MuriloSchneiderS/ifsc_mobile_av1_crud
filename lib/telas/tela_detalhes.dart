/*
2. O id e a descrição serão mostrados somente na tela de detalhes, nessa tela você poderá
realizar a tarefa.
*/
import 'package:flutter/material.dart';

class tela_detalhes extends StatelessWidget {
  final String titulo;
  const tela_detalhes({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: const Center(
        child: Text('Detalhes da Tarefa'),
      ),
    );
  }
}