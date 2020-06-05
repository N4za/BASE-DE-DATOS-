class Student{
  int controlnum;
  String name;
  String appP;
  String appM;
  String telef;
  String correo;
  String matricula;

  Student (this.controlnum, this.name, this.appP, this.appM, this.telef, this.correo, this.matricula);
  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      'controlnum': controlnum,
      'name': name,
      'app': appP,
      'appP': appM,
      'telef': telef,
      'correo': correo,
      'matricula': matricula,
    };
    return map;
  }

  Student.fromMap(Map<String, dynamic>map){
    controlnum = map['controlnum'];
    name = map['name'];
    appP = map['appP'];
    appM = map['appM'];
    telef = map['telef'];
    correo = map['correo'];
    matricula = map['matricula'];
  }
}