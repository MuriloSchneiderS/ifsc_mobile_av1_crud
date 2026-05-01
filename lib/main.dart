/*
7. Utilização de navegação com rotas nomeadas. Faça uma tela inicial de boas vindas que
mostra o título e data prevista da tarefa mais perto de ser vencida. -> tela_inicial.dart
[...]
9. Widgets Próprios: criação dos seus próprios componentes reutilizáveis (ex: um card de item
personalizado ou um botão estilizado) para promover o reuso de código.

10. Organização dos arquivos: separe em pastas, para os seus componentes, para as providers,
para as models, para as telas etc.

11. Deverá ser realizados em partes: será visto o histórico dos commits no seu repositório do
github (espera-se que ao menos três commits: por exemplo nos dias da aulas para realizar e
no dia da entrega 30/04, 07/05 e 08/05.

12. Entrega e apresentação para o professor: sexta dia 08/05. Deverá ser enviado o link do seu
repositório pelo moodle.
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/util/rotas.dart';
import 'telas/tela_inicial.dart';
import 'telas/tela_lista.dart';
import 'telas/tela_form.dart';
import 'telas/tela_detalhes.dart';
import 'providers/tarefa_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TarefaProvider(),
      child: MaterialApp(
        title: 'App de Tarefas',
        theme: ThemeData(
          colorScheme:  ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        initialRoute: Rotas.telaInicial,
        routes: {
          Rotas.telaInicial: (context) => const tela_inicial(titulo: 'Início'),
          Rotas.telaLista: (context) => const tela_lista(titulo: 'Lista de Tarefas'),
          Rotas.telaForm: (context) => const tela_form(titulo: 'Formulário de Tarefas'),
          Rotas.telaDetalhes: (context) => const tela_detalhes(titulo: 'Detalhes da Tarefa'),
        },
      ),
    );
  }
}