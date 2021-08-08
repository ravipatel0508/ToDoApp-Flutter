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
  TextEditingController _textEditingController =
      TextEditingController(text: 'yy');

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
                        .addTodo(Todo(_textEditingController.text));
                  },
                  child: Icon(Icons.add),
                )
              ]),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Consumer<ToDoService>(
                  builder: (context, value, child) => ListView.builder(
                    itemCount: value.todos.length,
                    itemBuilder: (context, index) => Card(
                      elevation: 10,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ListTile(
                          leading: Checkbox(
                            value: true,
                            onChanged: (value) {},
                          ),
                          title: Text(value.todos[index].title),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    var tempTodo = Todo("update");
                                    tempTodo.id = value.todos[index].id;
                                    context
                                        .read<ToDoService>()
                                        .updateTodo(tempTodo);
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<ToDoService>()
                                        .deleteTodo(value.todos[index].id);
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
