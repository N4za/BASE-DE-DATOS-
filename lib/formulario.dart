import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'main.dart';

class formulario extends StatefulWidget {
  @override
  _MyFormuler createState() => new _MyFormuler();
}

class _MyFormuler extends State<formulario> {
//Variables manejo BD
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

  void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name, surname, mail, num, matri);
        bdHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name, surname, mail, num, matri);
        bdHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }

  final formkey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Basic SQL operations"),
        backgroundColor: Colors.yellow,
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              TextFormField(
                controller: controller1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Student Name"),
                validator: (val) => val.length == 0 ? 'Enter name' : null,
                onSaved: (val) => name = val,
              ),
              TextFormField(
                controller: controller2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Student Surname"),
                validator: (val) => val.length == 0 ? 'Enter surname' : null,
                onSaved: (val) => surname = val,
              ),
              TextFormField(
                controller: controller3,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Student Mail"),
                validator: (val) => !val.contains('@') ? 'Enter mail' : null,
                onSaved: (val) => mail = val,
              ),
              TextFormField(
                controller: controller4,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Student phone"),
                validator: (val) =>
                val.length < 10 ? 'Enter phone number' : null,
                onSaved: (val) => num = val,
              ),
              TextFormField(
                controller: controller5,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Matricula"),
                validator: (val) => val.length == 0 ? 'Enter matri' : null,
                onSaved: (val) => matri = val,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.yellow)),
                    onPressed: dataValidate,
                    child: Text(isUpdating ? 'Update' : 'Add Data'),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.yellow)),
                    onPressed: () {
                      setState(() {
                        isUpdating = false;
                      });
                      cleanData();
                    },
                    child: Text('Cancel'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}