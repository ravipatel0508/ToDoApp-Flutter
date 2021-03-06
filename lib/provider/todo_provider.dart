import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/service/todo.dart';

class ToDoService with ChangeNotifier {
  bool checkBoxValue = false;
  bool isText = true;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addTodo(Todo todo) async {
    String dateTime = DateTime.now().toString();
    await firestore.collection('todos').doc(dateTime).set({
      'title': todo.title,
      'isCheck': false,
      'isText': true,
      'timeStamp': FieldValue.serverTimestamp()
    });

    notifyListeners();
  }

  Future updateTodo(Todo todo, bol) async {
    bol ? bol = false : bol = true;
    log(todo.id.toString());
    try {
      await firestore.collection('todos').doc(todo.id).update({
        'title': todo.title,
        'isCheck': false,
        'isText': bol,
        'timeStamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future deleteTodo(id) async {
    try {
      await firestore.collection('todos').doc(id).delete();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future checkBox(bool val, id) async {
    try {
      await firestore.collection('todos').doc(id).update({'isCheck': val});
    } catch (e) {
      print(e);
    }
    checkBoxValue = val;

    notifyListeners();
  }
}
