import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "ucoPunto", home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: ListTile(
          leading: Icon(Icons.location_on),
          title: Text(document['place'].toUpperCase() +
              '\n' +
              'Espera hasta las ' +
              document['leavingTime']),
          subtitle: Text(document['name']),
          trailing: FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('¡TE LLEVO!'),
              onPressed: () {
                document.reference.updateData({
                  'accepted': true,
                });
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viajes disponibles'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('ride').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
                child:
                    CircularProgressIndicator(backgroundColor: Colors.green));
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                if (snapshot.data.documents[index]['accepted'] == false) {
                  return _buildListItem(
                      context, snapshot.data.documents[index]);
                } else {
                  return Container();
                }
              });
        },
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
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _place;
  String _leavingTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir un viaje'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (String value) => _name = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Debes introducir un nombre.";
                    }

                    if (value.length < 2) {
                      return "Un nombre debe tener más de un caracter.";
                    }
                  },
                  decoration: InputDecoration(labelText: "Nombre"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (String value) => _place = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Debes introducir un destino.";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Destino",
                    helperText:
                        "Indica una zona en la que te vendría bien que te dejaran.",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (String value) => _leavingTime = value,
                  validator: (value) {
                    RegExp regex = new RegExp("([0-1][0-9]|2[0-3]):[0-5][0-9]");
                    if (!regex.hasMatch(value)) {
                      return "El formato ha de ser hh:mm.";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "hh:mm",
                    helperText:
                        "Indica hasta que hora puedes esperar en el Punto.",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(35),
                child: RaisedButton(
                  child: Text('GUARDAR'),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Firestore.instance.collection('ride').document().setData({
                        'accepted': false,
                        'name': _name,
                        'leavingTime': _leavingTime,
                        'place': _place
                      });
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => MyHome()),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
