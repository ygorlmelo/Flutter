import 'package:flutter/material.dart';
import 'package:keep_app/db/dbmanager.dart';

class PaginaListaDeTarefas extends StatefulWidget {
  @override
  _PaginaListaDeTarefasState createState() => _PaginaListaDeTarefasState();
}

class _PaginaListaDeTarefasState extends State<PaginaListaDeTarefas> {
  final DbListaTarefas dbmanager = new DbListaTarefas();

  final _tarefaController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  Tarefa tarefa;
  List<Tarefa> tarefaList;
  int updateIndex;

  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas Tarefas'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Inserir tarefa'),
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                    controller: _tarefaController,
                    validator: (val) =>
                      val.isNotEmpty ? null: 'Informe uma tarefa!',
                  ),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightGreen,
                    child: Container(
                      child: Text(
                        'Inserir',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontSize: 19.0,
                        ),
                      ),),
                    onPressed: (){
                      _salvarTarefa(context);
                    },
                  ),
                  FutureBuilder(
                    future: dbmanager.getTarefaList(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        tarefaList = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: tarefaList == null ?0 : tarefaList.length,
                          itemBuilder: (BuildContext context, int index){
                            Tarefa tr = tarefaList[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: width*0.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(' ${tr.descricao}',
                                            style: TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                  ),

                                  IconButton(onPressed: (){
                                    _tarefaController.text=tr.descricao;
                                    tarefa=tr;
                                    updateIndex = index;
                                  }, icon: Icon(Icons.edit, color: Colors.blueAccent,),),
                                  IconButton(onPressed: (){
                                    dbmanager.deletarTarefa(tr.id);
                                    setState(() {
                                      tarefaList.removeAt(index);
                                    });
                                  }, icon: Icon(Icons.delete, color: Colors.red,),)
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return new CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _salvarTarefa(BuildContext context){
    if(_formKey.currentState.validate()){
      if(tarefa == null){
        Tarefa tr = new Tarefa(descricao: _tarefaController.text);
        dbmanager.inserirTarefa(tr).then((id)=>{
          _tarefaController.clear(),
          print('Tarefa adicionada ao banco de dados ${id}')
        });
      }else{
        tarefa.descricao = _tarefaController.text;

        dbmanager.atualizarTarefa(tarefa).then((id) => {
          setState((){
            tarefaList[updateIndex].descricao = _tarefaController.text;
          }),
          _tarefaController.clear(),
          tarefa = null
        });
      }
    }
  }
}
