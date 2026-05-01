/*
3. Na tela de inserir e editar você deverá trabalhar com datas. Para tanto utilize o widget
ShowDatePicker do flutter (https://api.flutter.dev/flutter/material/showDatePicker.html).
4. Na tela de edição você poderá editar os demais campos, mas não realizar a tarefa.

tela de edição será só a tela de inserção, mas com os campos carregados e o botão de salvar alterado para editar.
*/
import 'package:flutter/material.dart';

class tela_form extends StatelessWidget {
  final String titulo;
  const tela_form({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: const Center(
        child: Text('Formulário de Tarefas'),
      ),
    );
  }
}