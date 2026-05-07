/*
2. O id e a descrição serão mostrados somente na tela de detalhes, nessa tela você poderá
realizar a tarefa.
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/models/tarefa.dart';

class TelaDetalhes extends StatelessWidget {
  final String titulo;
  const TelaDetalhes({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    //! programador garante que nao sera nulo, pois tem uma rota associada
    Tarefa tarefa = ModalRoute.of(context)?.settings.arguments as Tarefa ;
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text("tela DETALHES", 
              style: TextStyle(fontSize: 24)
              ),
            Text("Título: ${tarefa.titulo}"),
            Text("Descrição: ${tarefa.descricao}"),
            Text("Responsável: ${tarefa.responsavel}"),
            Text("Data Prevista: ${tarefa.dataPrevista.toLocal()}"),
            Text("Importante: ${tarefa.importante ? 'Sim' : 'Não'}"),
            Text("Realizada: ${tarefa.realizada ? 'Sim' : 'Não'}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'voltar',
        child: const Icon(Icons.arrow_back_sharp),
      ),
    );
  }
}