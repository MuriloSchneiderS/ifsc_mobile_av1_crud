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
  int? _tarefaId;
  DateTime dataPrevista = DateTime.now();
  var _importante = false;
  var _realizada = false;
  var _editando = false;
  var _salvando = false;
  //controladores para os campos de texto
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _responsavelController = TextEditingController();

  String _formataDataPrevista() {//dd/MM/yyyy HH:mm
    final local = dataPrevista.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year;
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Future<void> _selecionarDataHora() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dataPrevista,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) {//verifica se o usuário cancelou a seleção ou se o widget foi desmontado
      return;
    }

    final TimeOfDay initialTime = TimeOfDay.fromDateTime(dataPrevista);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime == null) {//verifica se o usuário cancelou a seleção de horário
      return;
    }

    setState(() {//atualiza a data prevista com a data e hora selecionadas
      dataPrevista = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _salvarTarefa() async {
    if (_salvando) {//evita que o usuário clique várias vezes no botão de salvar enquanto a tarefa está sendo salva
      return;
    }

    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {//exibe mensagem de erro se o título estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um título para a tarefa.')),
      );
      return;
    }
    final descricao = _descricaoController.text.trim();
    final responsavel = _responsavelController.text.trim();

    _salvando = true;
    setState(() {});//atualiza o estado para mostrar o indicador de carregamento no botão de salvar

    try {
      final tarefa = Tarefa(
        titulo: titulo,
        descricao: descricao,
        responsavel: responsavel,
        dataPrevista: dataPrevista,
        importante: _importante,
        realizada: _realizada,
      );
      if (_tarefaId != null) {//se já tiver id, esta editando e deve manter o id
        tarefa.id = _tarefaId!;
      }

      final provider = Provider.of<TarefaProvider>(context, listen: false);
      if (_editando && _tarefaId != null) {
        await provider.updateTarefa(_tarefaId!, tarefa);
      } else {
        await provider.addTarefa(tarefa);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } finally {//garante que o estado de salvando seja atualizado mesmo que ocorra um erro
      if (mounted) {
        _salvando = false;
        setState(() {});//atualiza o estado para esconder o indicador de carregamento no botão de salvar
      }
    }
  }

  var _initialized = false;

  @override
  void didChangeDependencies() {//carrega os dados da tarefa para edição
    super.didChangeDependencies();
    //evita que o código seja executado mais de uma vez
    if (_initialized) return;
      _initialized = true;
    
    final args = ModalRoute.of(context)?.settings.arguments;//pega os argumentos passados para a rota, que nesse caso é a tarefa a ser editada
    if (args is Tarefa) {
      _editando = true;
      _tarefaId = args.id;
      _tituloController.text = args.titulo;
      _descricaoController.text = args.descricao;
      _responsavelController.text = args.responsavel;
      dataPrevista = args.dataPrevista;
      _importante = args.importante;
      _realizada = args.realizada;
    }
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
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _responsavelController,
              decoration: InputDecoration(labelText: 'Responsável'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text('Data Prevista: ${_formataDataPrevista()}'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _selecionarDataHora,
                  child: const Text('Selecionar data e hora'),
                ),
              ],
            ),
            SwitchListTile(
              title: Text('Importante'),
              value: _importante,
              onChanged: (value) {
                setState(() {//atualiza o estado de importante quando o switch for alternado
                  _importante = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Realizada'),
              value: _realizada,
              onChanged: _editando ? null : (value) {
                setState(() {//atualiza o estado de realizada quando o switch for alternado
                  _realizada = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _salvando ? null : _salvarTarefa,
              child: _salvando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_editando ? 'Atualizar' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _responsavelController.dispose();
    super.dispose();
  }
}
