import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.blueGrey),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: Insert(),
    );
  }
}

class Insert extends StatefulWidget {
  @override
  _myInsert createState() => new _myInsert();
}

class _myInsert extends State<Insert> {
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
  String appP;
  String appM;
  String telef;
  String correo;
  String matricula;

  final formkey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  void dataValidate() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name, appP, appM, telef, correo, matricula);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(
            null,
            name,
            appP,
            appM,
            telef,
            correo,
            matricula);

        var validation = await dbHelper.validateInsert(stu);
        print(validation);
        if (validation) {
          dbHelper.insert(stu);
          final snackBar = SnackBar(
            backgroundColor: Colors.yellow,
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else{
          final snackBar = SnackBar(
            backgroundColor: Colors.yellow,
            content: Text('Registro insertado, ve a Actualizacion'),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }

      cleanData();
      refreshList();
    }
  }

  // FORMULARIO

  Widget form() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 35, right: 35, top: 0),
        child: SingleChildScrollView(
          child: Container(
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
                      cursorColor: Colors.blueAccent,
                      cursorRadius: Radius.circular(10.0),
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                      cursorWidth: 5.0,
                      controller: controller1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Nombre"),
                      validator: (val) => val.length == 0 ? 'Verifica este campo' : null,
                      onSaved: (val) => name = val,
                    ),

                    new SizedBox(height: 10.0),
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      cursorRadius: Radius.circular(10.0),
                      cursorWidth: 5.0,
                      controller: controller2,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: InputDecoration(labelText: "Apellido Paterno"),
                      validator: (val) => val.length == 0 ? 'Verifica este campo' : null,
                      onSaved: (val) => appP = val.toUpperCase().toString(),
                    ),

                    new SizedBox(height: 10.0),
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                      cursorRadius: Radius.circular(10.0),
                      cursorWidth: 5.0,
                      controller: controller3,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Apellido Materno"),
                      validator: (val) => val.length == 0 ? 'Verifica este campo' : null,
                      onSaved: (val) => appM = val.toString(),
                    ),

                    new SizedBox(height: 5.0),
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300),
                      cursorRadius: Radius.circular(10.0),
                      cursorWidth: 5.0,
                      controller: controller4,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Telefono"),
                      validator: (val) => val.length == 0 || val.contains(',') ? 'Verifica este campo' : null,
                      onSaved: (val) => telef = val.toString(),
                    ),

                    new SizedBox(height: 5.0),
                    TextFormField(
                      cursorColor: Colors.blueGrey,
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                      cursorRadius: Radius.circular(10.0),
                      cursorWidth: 5.0,
                      controller: controller5,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Correo"),
                      validator: (val) => val.length == 0 || !val.contains('@') || !val.contains('.') ? 'Verifica este campo' : null,
                      onSaved: (val) => correo = val.toString(),
                    ),

                    new SizedBox(height: 5.0),
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      textCapitalization: TextCapitalization.characters,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                      cursorRadius: Radius.circular(10.0),
                      cursorWidth: 5.0,
                      controller: controller6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Matricula"),
                      validator: (val) => val.length == 0 ? 'Verifica este campo' : null,
                      onSaved: (val) => matricula = val.toString(),
                    ),

                    SizedBox(height: 30),
                    SingleChildScrollView(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blueGrey),
                            ),
                            onPressed: dataValidate,
                            child: Text(isUpdating ? 'Insert' : 'Add Data'),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blueGrey),
                            ),
                            onPressed: () {
                              setState(() {
                                isUpdating = false;
                              });
                              cleanData();
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:_scaffoldKey,
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
        title: Text('Insercion'),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
          ],
        ),
      ),
    );
  }
}