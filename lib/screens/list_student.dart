import 'dart:io';

import 'package:flutter/material.dart';

import 'package:sqflite_student/db/function/db_function.dart';
import 'package:sqflite_student/db/model/db_model.dart';
import 'package:sqflite_student/screens/add_student.dart';

import 'edit_student.dart';

class Liststudent extends StatefulWidget {
  const Liststudent({super.key});

  @override
  State<Liststudent> createState() => _ListstudentState();
}

class _ListstudentState extends State<Liststudent> {
  final _namecontroller = TextEditingController();

  final _agecontroller = TextEditingController();

  final _phonecontroller = TextEditingController();

  final _placecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: studentlistNotifier,
        builder:
            (BuildContext ctx, List<Studentmodel> studentlist, Widget? child) {
          return SafeArea(
            child: ListView.separated(
                itemBuilder: (ctx, index) {
                  final data = studentlist[index];
                  return Card(
                    color: Colors.amber.shade500,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 34,
                            backgroundImage: FileImage(File(data.image)),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name : ${data.name}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Age : ${data.age}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Phone : ${data.phone}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Place : ${data.place}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return Updatepage(
                                            studentdetails: data,
                                          );
                                        },
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.amber.shade500,
                                              content: const Text(
                                                  'Do you want to delete ?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      if (data.id != null) {
                                                        await deletestudent(
                                                            data.id!);
                                                        delestudentdialogue(
                                                            context, data.name);
                                                      } else {
                                                        print(
                                                            'unable to delete');
                                                      }
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: const Text('No',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 253, 17, 0),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 1,
                  );
                },
                itemCount: studentlist.length),
          );
        });
  }

  clearcontroller() {
    _namecontroller.text = '';
    _agecontroller.text = '';
    _phonecontroller.text = '';
    _placecontroller.text = '';
    setState(() {
      image1 = null;
    });
  }
}

delestudentdialogue(context, name) {
  final _messege = 'Successfully Deleted';
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Color.fromARGB(255, 232, 107, 99),
    margin: const EdgeInsets.all(50),
    content: Text(
      _messege,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
    ),
  ));
}
