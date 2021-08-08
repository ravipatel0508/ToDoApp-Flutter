import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/service/todo.dart';

class ToDoService with ChangeNotifier {
  List todos = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _checkBoxValue = false;
  bool get checkBoxValue => _checkBoxValue;

  addTodo(Todo todo) async {
    await firestore.collection("todos").add({
      "title": todo.title,
    }).then((value) {
      todo.id = value.id;

      todos.add(todo);
    });

    notifyListeners();
  }

  updateTodo(Todo todo) async {
    try{
      await firestore.collection("todos").doc(todo.id).update({
        "title": todo.title,
        "isCheck": false
      });
    }catch(e){
      print(e);
    }
    //todos[index] = todo;
    notifyListeners();
  }

  deleteTodo(id) async {
    try{
      await firestore.collection("todos").doc(id).delete();
    }catch(e){
      print(e);
    }
    notifyListeners();
  }

  checkBox(bool val, id)async{
    try{
      await firestore.collection('todos').doc(id).update({"isCheck": val});
    }catch(e){

    }
      _checkBoxValue = val;
      notifyListeners();
      /*if(_checkBoxValue == true){
        _checkBoxValue = false;
      }
      else{
        _checkBoxValue = true;
      }*/
  }
}
