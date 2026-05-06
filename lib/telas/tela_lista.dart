/*
2. O id e a descrição serão mostrados somente na tela de detalhes, nessa tela você poderá
realizar a tarefa.
[...]
8. Para tela de listagem, deve ser feito filtros por tarefas: importantes ou não, realizadas ou
não, atrasadas ou não. Tente fazer utilizando o TabBar na sua AppBar (https://api.flutter.dev/
flutter/material/TabBar-class.html). Caso deseje a faça na parte inferior da tela do App.
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/models/tarefa.dart';
import 'package:ifsc_mobile_av1_crud/providers/tarefa_provider.dart';
import 'package:ifsc_mobile_av1_crud/util/rotas.dart';
import 'package:provider/provider.dart';

class TelaLista extends StatefulWidget {
  final String titulo;
  const TelaLista({super.key, required this.titulo});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
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
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return ListTile(
            title: Text(
              tarefa.titulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Data prevista: ${tarefa.dataPrevista.toLocal()}'),
            leading: Icon(
              tarefa.realizada ? Icons.check_circle : Icons.circle_outlined,
            ),
            trailing: Icon(tarefa.importante ? Icons.star : Icons.star_border),
            onTap: () {
              Navigator.pushNamed(
                context,
                Rotas.telaDetalhes,
                arguments: tarefa,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Rotas.telaForm);
        },
        child: Icon(Icons.list),
      ),
    );
  }
}
