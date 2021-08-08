import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/service/todo.dart';
import 'package:todo/provider/todo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textEditingController = TextEditingController(text: 'yy');
  bool _checkBoxValue = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('TO DO App'),
              SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term'),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    context
                        .read<ToDoService>()
                        .addTodo(Todo(title: _textEditingController.text));
                  },
                  child: Icon(Icons.add),
                )
              ]),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('todos').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> streamSnapshot) {
                    return Consumer<ToDoService>(
                      builder: (context, value, child) => ListView.builder(
                        itemCount: streamSnapshot.data.docs.length,
                        itemBuilder: (context, index) => Card(
                          elevation: 10,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ListTile(
                              leading: Checkbox(
                                value: streamSnapshot.data.docs[index]['isCheck'],
                                onChanged: (val) {
                                  context.read<ToDoService>().checkBox(val!,streamSnapshot.data.docs[index].id);
                                },
                              ),
                              title: Text(streamSnapshot.data.docs[index]['title']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () {
                                        var tempTodo = Todo(title: _textEditingController.text);
                                        tempTodo.id = streamSnapshot.data.docs[index].id;
                                        context.read<ToDoService>().updateTodo(tempTodo);
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        print('${streamSnapshot.data.docs[index].id}');
                                        //context.read<ToDoService>().deleteTodo(value.todos[index].id);
                                        context.read<ToDoService>().deleteTodo(streamSnapshot.data.docs[index].id);
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              )),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
