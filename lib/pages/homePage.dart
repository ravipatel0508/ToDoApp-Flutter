import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/service/todo.dart';
import 'package:todo/provider/todo_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _addTextEditingController = TextEditingController();
  TextEditingController _updateTextEditingController = TextEditingController();
  static const bgColor = const Color(0xffEBEBEB);
  final _formKey = GlobalKey<FormState>();

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
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Please enter your TODO...";
                                    }
                                    return null;
                                  },
                                  controller: _addTextEditingController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)
                                      ),
                                      hintText: 'Type something here...'),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            FloatingActionButton(
                              child: Icon(Icons.add),
                              backgroundColor: Colors.black,
                              mini: true,
                              tooltip: "Add TODO",
                              onPressed: () async{
                                if(_formKey.currentState!.validate()){
                                  await context.read<ToDoService>().addTodo(Todo(title: _addTextEditingController.text));
                                  _addTextEditingController.clear();
                                }
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
                                          borderRadius: BorderRadius.circular(7.0),
                                        ),
                                        elevation: 5,
                                        child: ListTile(
                                          leading: Checkbox(
                                            value: streamSnapshot.data.docs[index]['isCheck'],
                                            onChanged: (val) async{
                                              await context.read<ToDoService>().checkBox(val!, streamSnapshot.data.docs[index].id);
                                              },
                                          ),
                                          title: streamSnapshot.data.docs[index]['isText'] ? streamSnapshot.data.docs[index]['isCheck'] ? Text(streamSnapshot.data.docs[index]['title'], style: TextStyle(decoration: TextDecoration.lineThrough),) : Text(streamSnapshot.data.docs[index]['title'])
                                              : TextField(controller: _updateTextEditingController,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[


                                              IconButton(
                                                icon: streamSnapshot.data.docs[index]['isText'] ? Icon(Icons.edit) : Icon(Icons.check),
                                                onPressed: () async{
                                                  if(streamSnapshot.data.docs[index]['isText']){
                                                    _updateTextEditingController = TextEditingController(text: streamSnapshot.data.docs[index]['title']);
                                                  }

                                                  var tempTodo = Todo(title: _updateTextEditingController.text);

                                                  if(!streamSnapshot.data.docs[index]['isText'] && tempTodo.title.length == 0){
                                                    await context.read<ToDoService>().deleteTodo(streamSnapshot.data.docs[index].id);
                                                  }else{
                                                    tempTodo.id = streamSnapshot.data.docs[index].id;
                                                    await context.read<ToDoService>().updateTodo(tempTodo, streamSnapshot.data.docs[index]['isText']);
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async{
                                                  await context.read<ToDoService>().deleteTodo(streamSnapshot.data.docs[index].id);
                                                  },
                                              ),
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
