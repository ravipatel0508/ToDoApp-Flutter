import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('TO DO App'),
            SizedBox(height: 10),
            Row(children:[
              //TextField(),
              FloatingActionButton(onPressed: (){},child: Icon(Icons.add),)
            ]),
          ],
        ),
      ),
    );
  }
}
