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
  State<TelaDetalhes> createState() => _TelaDetalhesState(); //cria o estado onde a lógica de exibição dos detalhes da tarefa e ações de editar e excluir serão implementadas
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  late Tarefa tarefa;
  bool _carregando = false;

  @override
  void didChangeDependencies() {//método chamado quando as dependências do widget mudam, para carregar a tarefa passada como argumento
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
        setState(() {});//atualiza a interface para refletir a mudança no estado de carregamento
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Consumer<TarefaProvider>(
        builder: (context, provider, child) {
          // Encontra a tarefa atualizada no provider
          Tarefa? tarefaAtualizada;
          if (tarefa.id != null) {
            try {//tenta encontrar a tarefa atualizada com base no id
              tarefaAtualizada = provider.tarefas.firstWhere(
                (t) => t.id == tarefa.id,
              );
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
                Text(
                  "${tarefaAtualizada.id} - ${tarefaAtualizada.titulo}",
                  style: TextStyle(fontSize: 24),
                ),
                Text("Descrição: ${tarefaAtualizada.descricao}"),
                Text("Responsável: ${tarefaAtualizada.responsavel}"),
                Text("Data Prevista: ${tarefaAtualizada.dataFormatada}",),
                Text("Importante: ${tarefaAtualizada.importante ? 'Sim' : 'Não'}",),
                SizedBox(height: 20),
                SwitchListTile(//switch para marcar a tarefa como realizada ou não realizada
                  title: Text('Realizada: '),
                  value: tarefaAtualizada.realizada,
                  onChanged: _carregando
                      ? null
                      : (value) async {
                          if (_carregando) return;
                          _carregando = true;
                          setState(() {});
                          try {//nova instância de Tarefa com 'realizada' atualizada
                            final tarefaAtualizadaComRealizada = Tarefa(
                              titulo: tarefaAtualizada!.titulo,
                              descricao: tarefaAtualizada.descricao,
                              responsavel: tarefaAtualizada.responsavel,
                              dataPrevista: tarefaAtualizada.dataPrevista,
                              importante: tarefaAtualizada.importante,
                              realizada: value,
                            );
                            tarefaAtualizadaComRealizada.id =
                                tarefaAtualizada.id!;
                            final provider = Provider.of<TarefaProvider>(
                              context,
                              listen: false,
                            );
                            await provider.updateTarefa(
                              tarefaAtualizada.id!,
                              tarefaAtualizadaComRealizada,
                            );
                          } finally {
                            if (mounted) {
                              _carregando = false;
                              setState(() {});//atualiza a interface para refletir a mudança no estado de carregamento
                            }
                          }
                        },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _carregando
                          ? null
                          : () {
                              Navigator.pushNamed(
                                context,
                                '/tela_form',
                                arguments: tarefaAtualizada,
                              );
                            },
                      child: Text('Editar'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _carregando
                          ? null
                          : () {
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
