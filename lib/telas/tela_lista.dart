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
  bool filtroImportante = true;
  bool filtroRealizada = true;
  bool filtroAtrasada = true;
  final Set<int?> _atualizando = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TarefaProvider>(context, listen: false).loadTarefas(),
    );
  }

  Future<void> _atualizarTarefaComDebounce(int tarefaId, Tarefa tarefa) async {
    if (_atualizando.contains(tarefaId)) {
      return;
    }
    
    _atualizando.add(tarefaId);
    setState(() {});
    
    try {
      final provider = Provider.of<TarefaProvider>(context, listen: false);
      await provider.updateTarefa(tarefaId, tarefa);
    } finally {
      if (mounted) {
        _atualizando.remove(tarefaId);
        setState(() {});
      }
    }
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
                  _buildTabContent('importante'),
                  _buildTabContent('realizada'),
                  _buildTabContent('atrasada'),
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
    bool Function(Tarefa) filtroFn;
    Widget? alternaWidget;

    switch (tab) { //define a função de filtro e o widget de toggle para cada aba
      case 'all'://sem filtro, mostra todas as tarefas
        filtroFn = (t) => true;
        break;
      //cada caso define um filtro específico e um widget de toggle para ativar/desativar o filtro
      case 'importante':
        filtroFn = (t) => t.importante == filtroImportante;
        alternaWidget = SwitchListTile(
          title: Text(filtroImportante ? 'Importantes' : 'Não Importantes'),
          value: filtroImportante,
          onChanged: (v) => setState(() => filtroImportante = v),
        );
        break;
      case 'realizada':
        filtroFn = (t) => t.realizada == filtroRealizada;
        alternaWidget = SwitchListTile(
          title: Text(filtroRealizada ? 'Realizadas' : 'Não Realizadas'),
          value: filtroRealizada,
          onChanged: (v) => setState(() => filtroRealizada = v),
        );
        break;
      case 'atrasada':
        filtroFn = (t) => (t.dataPrevista.isBefore(DateTime.now()) && !t.realizada) == filtroAtrasada;
        alternaWidget = SwitchListTile(
          title: Text(filtroAtrasada ? 'Atrasadas' : 'Não Atrasadas'),
          value: filtroAtrasada,
          onChanged: (v) => setState(() => filtroAtrasada = v),
        );
        break;
      default:
        filtroFn = (t) => true;
    }

    return Column(
      children: [
        ?alternaWidget,
        Expanded(child: _buildFilteredListView(filtroFn)),
      ],
    );
  }

  Widget _buildFilteredListView(bool Function(Tarefa) filtroFn) {
    var provider = Provider.of<TarefaProvider>(context);
    final List<Tarefa> tarefas = provider.tarefas.where(filtroFn).toList();
    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        final isUpdating = _atualizando.contains(tarefa.id);
        return ListTile(
          title: Text(
            tarefa.titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Data prevista: ${tarefa.dataPrevista.toLocal().toString().substring(0, 16)}'),
          leading: IconButton(
            icon: Icon(
              tarefa.realizada ? Icons.check_circle : Icons.circle_outlined,
            ),
            onPressed: isUpdating ? null : () {
              _atualizarTarefaComDebounce(
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
            onPressed: isUpdating ? null : () {
              _atualizarTarefaComDebounce(
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
          onTap: isUpdating ? null : () {
            Navigator.pushNamed(context, Rotas.telaDetalhes, arguments: tarefa);
          },
        );
      },
    );
  }
}
