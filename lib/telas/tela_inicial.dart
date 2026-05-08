/*
7. Utilização de navegação com rotas nomeadas. Faça uma tela inicial de boas vindas que
mostra o título e data prevista da tarefa mais perto de ser vencida.
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/models/tarefa.dart';
import 'package:ifsc_mobile_av1_crud/providers/tarefa_provider.dart';
import 'package:ifsc_mobile_av1_crud/util/rotas.dart';
import 'package:provider/provider.dart';

class TelaInicial extends StatefulWidget {
  final String titulo;
  const TelaInicial({super.key, required this.titulo});

  @override
  State<TelaInicial> createState() => _TelaInicialState();//estado onde a lógica de exibição da tarefa mais próxima de vencer e navegação para a lista completa será implementada
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TarefaProvider>(context, listen: false).loadTarefas(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TarefaProvider>(context);
    final List<Tarefa> tarefas = provider.tarefas;
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
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
                  Text(//exibe o título e data prevista da tarefa mais próxima de vencer
                    '${tarefas[0].titulo} - ${tarefas[0].dataPrevista.toLocal().toString().substring(0, 16)}',//formata a data para exibir apenas data e hora
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
            Navigator.pushNamed(context, Rotas.telaForm);
          },
          child: Icon(Icons.add),
        ),
    );
  }
}
