import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "ucoPunto", home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viajes disponibles'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('VISTALEGRE\nPablo Rodríguez\nIn 10 minutes'),
                    trailing: FlatButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text('¡TE LLEVO!'),
                        onPressed: () {}),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RideForm()),
          );
        },
        backgroundColor: Colors.green,
        tooltip: 'Añade un viaje',
        child: Icon(Icons.add),
      ),
    );
  }
}

class RideForm extends StatefulWidget {
  @override
  _RideFormState createState() => _RideFormState();
}

class _RideFormState extends State<RideForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¿A dónde vas?'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[TextFormField()],
      ),
    );
  }
}
