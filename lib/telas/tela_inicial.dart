/*
7. Utilização de navegação com rotas nomeadas. Faça uma tela inicial de boas vindas que
mostra o título e data prevista da tarefa mais perto de ser vencida.
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/models/tarefa.dart';
import 'package:ifsc_mobile_av1_crud/providers/tarefa_provider.dart';
import 'package:ifsc_mobile_av1_crud/util/rotas.dart';
import 'package:provider/provider.dart';

class tela_inicial extends StatelessWidget {
  final String titulo;
  const tela_inicial({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TarefaProvider>(context);
    provider.loadTarefas();
    final List<Tarefa> tarefas = provider.tarefas;
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Center(

        child: tarefas.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bem-vindo!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Nenhuma tarefa cadastrada.'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bem-vindo!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tarefa mais próxima de vencer:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${tarefas[0].titulo} - ${tarefas[0].dataPrevista.toLocal()}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Rotas.telaLista);
                    },
                    child: Text('Ver lista completa'),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Rotas.telaLista);
        },
        child: Icon(Icons.list),
      ),
    );
  }
}