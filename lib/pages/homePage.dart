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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('TO DO App'),
              SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term'),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.add),
                )
              ]),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text('text...'),
                    trailing: IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
