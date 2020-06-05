import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'insert.dart';
import 'update.dart';
import 'delete.dart';
import 'select.dart';
import 'students.dart';
import 'dart:async';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: Search(),
    );
  }
}

class Search extends StatefulWidget {
  @override
  _mySearch createState() => new _mySearch();
}

class _mySearch extends State<Search> {

  Future<List<Student>> Students;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller7 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  int currentUserId;
  String name;
  String appP;
  String appM;
  String telef;
  String correo;
  String matricula;
  String search;
  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool _typing;


  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _typing = false;
  }

  void refreshList(String matricula) {
    setState(() {
      Students = dbHelper.getStudent(matricula);
    });
  }

  void cleanData() {
    controller7.text = "";
  }

  SingleChildScrollView dataTable(List<Student> Students) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Nombre."),
          ),
          DataColumn(
            label: Text("Apellido Paterno."),
          ),
          DataColumn(
            label: Text("Apellido Materno."),
          ),
          DataColumn(
            label: Text("Telefono."),
          ),
          DataColumn(
            label: Text("Correo."),
          ),
          DataColumn(
            label: Text("Matricula."),
          ),
        ],
        rows: Students.map((student) =>
            DataRow(
                selected: true,
                cells: [
                  DataCell(Text(student.name.toString().toUpperCase()),
                      onTap: () {
                        setState(() {
                          _typing = true;
                          currentUserId = student.controlnum;
                        });
                        controller1.text = student.name;
                      }),
                  DataCell(Text(student.appP.toString().toUpperCase()), onTap: () {
                    setState(() {
                      _typing = true;
                      currentUserId = student.controlnum;
                    });
                    controller2.text = student.appP;
                  }),

                  DataCell(Text(student.appM.toString().toUpperCase()), onTap: () {
                    setState(() {
                      _typing = true;
                      currentUserId = student.controlnum;
                    });
                    controller3.text = student.appM;
                  }),

                  DataCell(Text(student.telef.toString().toUpperCase()), onTap: () {
                    setState(() {
                      _typing = true;
                      currentUserId = student.controlnum;
                    });
                    controller4.text = student.telef;
                  }),

                  DataCell(Text(student.correo.toString().toUpperCase()), onTap: () {
                    setState(() {
                      _typing = true;
                      currentUserId = student.controlnum;
                    });
                    controller5.text = student.correo;
                  }),

                  DataCell(Text(student.matricula.toString().toUpperCase()), onTap: () {
                    setState(() {
                      _typing = true;
                      currentUserId = student.controlnum;
                    });
                    controller6.text = student.matricula;
                  }),
                ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Students,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data founded!");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  // FORMULARIO

  Widget form() {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              TextFormField(
                cursorColor: Colors.red,
                cursorRadius: Radius.circular(10.0),
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                cursorWidth: 5.0,
                controller: controller7,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Introduce una matricula"),
                validator: (val) => val.length == 0 ? 'Llena el campo para una busqueda correcta' : null,
                onSaved: (val) => search = val,
                onChanged: (text){
                  refreshList(text);
                },
              ),

              SizedBox(height: 30),
              SingleChildScrollView(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('MENU',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.blueGrey,),
              title: Text('Insertar'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Insert()));
              },
            ),
            ListTile(
              title: Text('Actualizar'),
              leading: Icon(Icons.update, color: Colors.blueGrey,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Update()));
              },
            ),
            ListTile(
              title: Text('Eliminar'),
              leading: Icon(Icons.delete, color: Colors.blueGrey,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Delete()));
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.blueGrey,),
              title: Text('Buscar'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Search()));
              },
            ),
          ],
        ),
      ),

      appBar: new AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Buscar'),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}