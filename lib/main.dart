import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'insert.dart';
import 'update.dart';
import 'delete.dart';
import 'select.dart';
import 'students.dart';
import 'dart:async';
import 'busqueda.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.yellow),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.yellow),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  // VAR MANEJO BD
  Future<List<Student>> Students;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  int currentUserId;
  String name;
  String photoName;
  String appP;
  String appM;
  String telef;
  String correo;
  String matricula;
  int currentUserId;
  
  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;


  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Students = dbHelper.getStudents();
    });
  }

  void cleanData() {
    controller1.text = "";
    controller2.text = "";
    controller3.text = "";
    controller4.text = "";
    controller5.text = "";
    controller6.text = "";
  }

  void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name, appP, appM, telef, correo, matricula);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name, appP, appM, telef, correo, matricula);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }

  // SHOW DATA
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
        rows: Students.map((student) => DataRow(cells: [
          DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controller1.text = student.name;
          }),
          DataCell(Text(student.appP.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controller2.text = student.appP;
          }),

          DataCell(Text(student.appM.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controller3.text = student.appM;
          }),

          DataCell(Text(student.telef.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controller4.text = student.telef;
          }),

          DataCell(Text(student.correo.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controller5.text = student.correo;
          }),

          DataCell(Text(student.matricula.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
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
        backgroundColor: Colors.lightBlueAccent,
        title: Text('SQLite'),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }
}
