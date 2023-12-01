import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_student/db/function/db_function.dart';
import 'package:sqflite_student/screens/add_student.dart';
import 'package:sqflite_student/screens/list_student.dart';
import 'package:sqflite_student/screens/search_details.dart';

import '../db/model/db_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    getallstudent();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 60),
                child: Text(
                  'WELCOME',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: search(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
            ),
          ],
          backgroundColor: Colors.amber.shade500,
        ),
        body: SafeArea(
            child: Column(
          children: [
            const Flexible(flex: 8, child: Liststudent()),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.amber.shade500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (ctx) {
                              return const Studentadd();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 0, 0)),
                          child: const Text(
                            'Add student',
                          )),
                    ],
                  ),
                ))
          ],
        )));
  }
}

class search extends SearchDelegate {
  List data = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: studentlistNotifier,
        builder: (BuildContext context, List<Studentmodel> studentlist,
            Widget? child) {
          return ListView.builder(
            itemBuilder: (ctx, index) {
              final data = studentlist[index];
              String nameval = data.name;
              if ((nameval).contains(query)) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Details(
                            studentdetails: data,
                          );
                        }));
                      },
                      title: Text(data.name),
                      leading: CircleAvatar(
                        backgroundImage: FileImage(File(data.image)),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              } else {
                return Container();
              }
            },
            itemCount: studentlist.length,
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: studentlistNotifier,
        builder: (BuildContext context, List<Studentmodel> studentlist,
            Widget? child) {
          return ListView.builder(
            itemBuilder: (ctx, index) {
              final data = studentlist[index];
              String nameval = data.name;
              if ((nameval).contains((query.trim()))) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Details(
                            studentdetails: data,
                          );
                        }));
                      },
                      title: Text(data.name),
                      leading: CircleAvatar(
                        backgroundImage: FileImage(File(data.image)),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              } else {
                print('no result');
              }
              return null;
            },
            itemCount: studentlist.length,
          );
        });
  }
}
