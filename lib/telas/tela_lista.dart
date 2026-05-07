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
  bool importantFilter = true;
  bool completedFilter = true;
  bool overdueFilter = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TarefaProvider>(context, listen: false).loadTarefas(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.titulo),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent('all'),
                  _buildTabContent('important'),
                  _buildTabContent('completed'),
                  _buildTabContent('overdue'),
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(text: 'Todas'),
                Tab(text: 'Importantes'),
                Tab(text: 'Realizadas'),
                Tab(text: 'Atrasadas'),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Rotas.telaForm);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTabContent(String tab) {
    bool Function(Tarefa) filterFn;
    Widget? toggleWidget;

    switch (tab) { //define a função de filtro e o widget de toggle para cada aba
      case 'all':
        filterFn = (t) => true;//sem filtro, mostra todas as tarefas
        break;
      //cada caso define um filtro específico e um widget de toggle para ativar/desativar o filtro
      case 'important':
        filterFn = (t) => t.importante == importantFilter;
        toggleWidget = SwitchListTile(
          title: Text(importantFilter ? 'Importantes' : 'Não Importantes'),
          value: importantFilter,
          onChanged: (v) => setState(() => importantFilter = v),
        );
        break;
      case 'completed':
        filterFn = (t) => t.realizada == completedFilter;
        toggleWidget = SwitchListTile(
          title: Text(completedFilter ? 'Realizadas' : 'Não Realizadas'),
          value: completedFilter,
          onChanged: (v) => setState(() => completedFilter = v),
        );
        break;
      case 'overdue':
        filterFn = (t) => (t.dataPrevista.isBefore(DateTime.now()) && !t.realizada) == overdueFilter;
        toggleWidget = SwitchListTile(
          title: Text(overdueFilter ? 'Atrasadas' : 'Não Atrasadas'),
          value: overdueFilter,
          onChanged: (v) => setState(() => overdueFilter = v),
        );
        break;
      default:
        filterFn = (t) => true;
    }

    return Column(
      children: [
        if (toggleWidget != null) toggleWidget,
        Expanded(child: _buildFilteredListView(filterFn)),
      ],
    );
  }

  Widget _buildFilteredListView(bool Function(Tarefa) filterFn) {
    var provider = Provider.of<TarefaProvider>(context);
    final List<Tarefa> tarefas = provider.tarefas.where(filterFn).toList();
    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        return ListTile(
          title: Text(
            tarefa.titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Data prevista: ${tarefa.dataPrevista.toLocal()}'),
          leading: IconButton(
            icon: Icon(
              tarefa.realizada ? Icons.check_circle : Icons.circle_outlined,
            ),
            onPressed: () {
              provider.updateTarefa(
                tarefa.id!,
                Tarefa(
                  titulo: tarefa.titulo,
                  descricao: tarefa.descricao,
                  responsavel: tarefa.responsavel,
                  dataPrevista: tarefa.dataPrevista,
                  importante: tarefa.importante,
                  realizada: !tarefa.realizada,
                ),
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(tarefa.importante ? Icons.star : Icons.star_border),
            onPressed: () {
              provider.updateTarefa(
                tarefa.id!,
                Tarefa(
                  titulo: tarefa.titulo,
                  descricao: tarefa.descricao,
                  responsavel: tarefa.responsavel,
                  dataPrevista: tarefa.dataPrevista,
                  importante: !tarefa.importante,
                  realizada: tarefa.realizada,
                ),
              );
            },
          ),
          onTap: () {
            Navigator.pushNamed(context, Rotas.telaDetalhes, arguments: tarefa);
          },
        );
      },
    );
  }
}
