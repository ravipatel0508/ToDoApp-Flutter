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
  TextEditingController _textEditingController = TextEditingController();
  static const bgColor = const Color(0xffEBEBEB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('todos').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<dynamic> streamSnapshot) {
            return streamSnapshot.hasData
                ? Container(
                    color: bgColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'TO DO App',
                            style: TextStyle(fontSize: 40),
                          ),
                          SizedBox(height: 20),
                          Row(children: [
                            Flexible(
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    focusColor: Colors.amberAccent,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: 'Type something here...'),
                              ),
                            ),
                            SizedBox(width: 10),
                            FloatingActionButton(
                              child: Icon(Icons.add),
                              backgroundColor: Colors.black,
                              mini: true,
                              tooltip: "Add TODO",
                              onPressed: () {
                                context.read<ToDoService>().addTodo(
                                    Todo(title: _textEditingController.text));
                              },
                            )
                          ]),
                          SizedBox(height: 20),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: Consumer<ToDoService>(
                              builder: (context, value, child) =>
                                  ListView.builder(
                                itemCount: streamSnapshot.data.docs.length,
                                itemBuilder: (context, index) => Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7.0)),
                                    elevation: 5,
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: streamSnapshot.data.docs[index]
                                            ['isCheck'],
                                        onChanged: (val) {
                                          context.read<ToDoService>().checkBox(
                                              val!,
                                              streamSnapshot.data.docs[index].id);
                                        },
                                      ),
                                      title: Text(streamSnapshot.data.docs[index]
                                          ['title']),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                              onPressed: () {
                                                var tempTodo = Todo(
                                                    title: _textEditingController
                                                        .text);
                                                tempTodo.id = streamSnapshot
                                                    .data.docs[index].id;
                                                context
                                                    .read<ToDoService>()
                                                    .updateTodo(tempTodo);
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                context
                                                    .read<ToDoService>()
                                                    .deleteTodo(streamSnapshot
                                                        .data.docs[index].id);
                                              },
                                              icon: Icon(Icons.delete)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
