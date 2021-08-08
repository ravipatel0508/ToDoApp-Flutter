import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/service/todo.dart';

class ToDoService with ChangeNotifier{
  List<Todo> todos = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  addTodo(Todo todo) async{

    await firestore.collection("todos").add({
      "title" : todo.title,
    }).then((value) {
      todo.id = value.id;

      todos.add(todo);
    });

    notifyListeners();
  }

  deleteTodo(id)async{

    var index = todos.indexWhere((element) => element.id == id);
    if(index != -1){
      await firestore.collection("todos").doc(id).delete();
      todos.removeAt(index);
    }
    notifyListeners();
  }

  updateTodo(Todo todo)async{

    var index = todos.indexWhere((element) => element.id == todo.id);
    if(index != -1){
      await firestore.collection("todos").doc(todo.id).update({
        "title": todo.title,
      });
      todos[index] = todo;
    }
    notifyListeners();
  }
}