import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState(){
    _readData().then((data) => {
      setState((){
        _toDoList = json.decode(data);
      })
    });
  }

  List _toDoList = [];

  final toDoController = new TextEditingController();

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = new Map();
      newToDo["title"] = toDoController.text;
      toDoController.text = null;
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: toDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.blue))),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    child: Text(
                      "ADD",
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _addToDo,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_toDoList[index]["title"]),
                    value: _toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(
                          _toDoList[index]["ok"] ? Icons.check : Icons.error),
                    ),
                    onChanged: (c) {
                      setState(() {
                        _toDoList[index]["ok"] = c;
                        _saveData();
                      });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
