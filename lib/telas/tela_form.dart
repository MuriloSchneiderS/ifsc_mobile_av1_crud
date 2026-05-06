/*
3. Na tela de inserir e editar você deverá trabalhar com datas. Para tanto utilize o widget
ShowDatePicker do flutter (https://api.flutter.dev/flutter/material/showDatePicker.html).
4. Na tela de edição você poderá editar os demais campos, mas não realizar a tarefa.

tela de edição será só a tela de inserção, mas com os campos carregados e o botão de salvar alterado para editar.
*/
import 'package:flutter/material.dart';
import 'package:ifsc_mobile_av1_crud/models/tarefa.dart';
import 'package:ifsc_mobile_av1_crud/providers/tarefa_provider.dart';
import 'package:provider/provider.dart';

class TelaForm extends StatefulWidget {
  final String titulo;
  const TelaForm({super.key, required this.titulo});

  @override
  State<TelaForm> createState() => _TelaFormState();
}

class _TelaFormState extends State<TelaForm> {
  var _importante = false;
  var _realizada = false;
  final _tituloController = TextEditingController();

  Future<void> _salvarTarefa() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um título para a tarefa.')),
      );
      return;
    }
    final descricao = TextEditingController().text.trim();
    final responsavel = TextEditingController().text.trim();

    final tarefa = Tarefa(
      titulo: titulo,
      descricao: descricao,
      responsavel: responsavel,
      dataPrevista: DateTime.now(),
      importante: _importante,
      realizada: _realizada,
    );

    final provider = Provider.of<TarefaProvider>(context, listen: false);
    await provider.addTarefa(tarefa);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
             TextField(
              decoration: InputDecoration(labelText: 'Responsável'),
            ),
            SwitchListTile(
              title: Text('Importante'),
              value: _importante,
              onChanged: (value) {
                setState(() {
                  _importante = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Realizada'),
              value: _realizada,
              onChanged: (value) {
                setState(() {
                  _realizada = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _salvarTarefa,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
