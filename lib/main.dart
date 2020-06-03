import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'dart:async';
import 'formulario.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  String name;
  String surname;
  String mail;
  String num;
  String matri;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey=GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents();
    });
  }

  void cleanData() {
    controller1.text = "";
    controller2.text = "";
    controller3.text = "";
    controller4.text = "";
    controller5.text = "";
  }



  Widget menu(){
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Text("MENU",
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
                color: Colors.yellow
            ),
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('FORMULARIO'),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => formulario()));
            },
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('ACTUALIZAR'),
            onTap: refreshList,
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('ELIMINAR'),
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text('INSERTAR'),
          )
        ],
      ),
    );
  }

  //Datos a mostrar
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Control"),
          ),
          DataColumn(
            label: Text("Name"),
          ),
          DataColumn(
            label: Text("Surname"),
          ),
          DataColumn(
            label: Text("Mail"),
          ),
          DataColumn(
            label: Text("Numero"),
          ),
          DataColumn(
            label: Text("Mtricula"),
          ),
          DataColumn(label: Text("Delete")),
          DataColumn(label: Text("Update"))
        ],
        rows: Studentss.map((student) => DataRow(cells: [
          DataCell(Text(student.controlum.toString())),
          DataCell(
            Text(student.name.toUpperCase()),
            onTap: () {
              setState(() {
                isUpdating = true;
                currentUserId = student.controlum;
              });
              controller1.text = student.name;
            },
          ),
          DataCell(Text(student.surname.toUpperCase())),
          DataCell(Text(student.mail.toUpperCase())),
          DataCell(Text(student.num.toUpperCase())),
          DataCell(Text(student.matri.toUpperCase())),
          DataCell(IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              bdHelper.delete(student.controlum);
              refreshList();
              _alert(context, "Elemento eliminado");
            },
          )),
          DataCell(IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              bdHelper.update(student.controlum);
              refreshList();
            },
          ))
        ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldkey,
      drawer: menu(),
      appBar: new AppBar(
        title: Text("Basic SQL operations"),
        backgroundColor: Colors.yellow,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
            //NavDrawer(),
          ],
        ),
      ),
    );
  }
  _alert(BuildContext,String texto){
    final snackbar = SnackBar(
      content: new Text(texto),
      backgroundColor: Colors.yellow,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }
}