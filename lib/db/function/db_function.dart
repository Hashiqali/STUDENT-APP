import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_student/db/model/db_model.dart';

ValueNotifier<List<Studentmodel>> studentlistNotifier = ValueNotifier([]);

late Database _db;

Future<void> initializingdatabase() async {
  _db = await openDatabase('student.db', version: 1,
      onCreate: (Database db, int version) {
    db.execute('''CREATE TABLE student(
          id INTEGER PRIMARY KEY,
          name TEXT,
          age TEXT,
          phone TEXT,
          place TEXT,
          image TEXT
          )''');
  });
}

Future<void> addstudent1(Studentmodel value) async {
  await _db.execute(
      'INSERT INTO student(name,age,phone,place,image)VALUES(?,?,?,?,?)',
      [value.name, value.age, value.phone, value.place, value.image]);

  getallstudent();
}

Future<void> getallstudent() async {
  final _values = await _db.rawQuery('SELECT * FROM student');
  print(_values);

  studentlistNotifier.value.clear();

  _values.forEach((map) {
    final student = Studentmodel.fromMap(map);
    studentlistNotifier.value.add(student);
  });
  studentlistNotifier.notifyListeners();
}

Future<void> deletestudent(int id) async {
  await _db.delete("student", where: "id=?", whereArgs: [id]);
  getallstudent();
}

Future<void> updatestudent(int id, String name, String age, String phone,
    String place, String image) async {
  final data = {
    'name': name,
    'age': age,
    'phone': phone,
    'place': place,
    'image': image,
  };
  await _db.update('student', data, where: 'id=?', whereArgs: [id]);

  getallstudent();
}
