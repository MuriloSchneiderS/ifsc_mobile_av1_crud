/*
2. O id e a descrição serão mostrados somente na tela de detalhes, nessa tela você poderá
realizar a tarefa.
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/models/tarefa.dart';
import 'package:ifsc_mobile_av1_crud/providers/tarefa_provider.dart';
import 'package:provider/provider.dart';

class TelaDetalhes extends StatefulWidget {
  final String titulo;
  const TelaDetalhes({super.key, required this.titulo});

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();//cria o estado onde a lógica de exibição dos detalhes da tarefa e ações de editar e excluir serão implementadas
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  late Tarefa tarefa;
  bool _carregando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    tarefa = ModalRoute.of(context)?.settings.arguments as Tarefa;
  }

  Future<void> _deletarTarefa(Tarefa tarefaAtualizada) async {
    if (_carregando || tarefaAtualizada.id == null) {
      return;
    }

    _carregando = true;
    setState(() {});

    try {
      final provider = Provider.of<TarefaProvider>(context, listen: false);
      await provider.deleteTarefa(tarefaAtualizada.id!);
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        _carregando = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: Consumer<TarefaProvider>(
        builder: (context, provider, child) {
          // Encontra a tarefa atualizada no provider
          Tarefa? tarefaAtualizada;
          if (tarefa.id != null) {
            try {
              tarefaAtualizada = provider.tarefas
                  .firstWhere((t) => t.id == tarefa.id);
            } catch (e) {
              tarefaAtualizada = tarefa;
            }
          } else {
            tarefaAtualizada = tarefa;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${tarefaAtualizada.id} - ${tarefaAtualizada.titulo}", 
                  style: TextStyle(fontSize: 24)
                  ),
                Text("Descrição: ${tarefaAtualizada.descricao}"),
                Text("Responsável: ${tarefaAtualizada.responsavel}"),
                Text("Data Prevista: ${tarefaAtualizada.dataPrevista.toString().substring(0, 16)}"),
                Text("Importante: ${tarefaAtualizada.importante ? 'Sim' : 'Não'}"),
                Text("Realizada: ${tarefaAtualizada.realizada ? 'Sim' : 'Não'}"),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _carregando ? null : () {
                        Navigator.pushNamed(context, '/tela_form', arguments: tarefaAtualizada);
                      },
                      child: Text('Editar'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _carregando ? null : () {
                        _deletarTarefa(tarefaAtualizada!);
                      },
                      child: _carregando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Excluir'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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