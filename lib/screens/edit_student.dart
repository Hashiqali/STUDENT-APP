import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_student/screens/homescreen.dart';
import 'package:sqflite_student/screens/add_student.dart';
import '../db/function/db_function.dart';

class Updatepage extends StatefulWidget {
  const Updatepage({super.key, this.studentdetails});
  final studentdetails;
  @override
  State<Updatepage> createState() => _UpdatepageState();
}

class _UpdatepageState extends State<Updatepage> {
  final _namecontroller = TextEditingController();

  final _agecontroller = TextEditingController();

  final _phonecontroller = TextEditingController();

  final _placecontroller = TextEditingController();
  @override
  void initState() {
    _namecontroller.text = widget.studentdetails.name;
    _agecontroller.text = widget.studentdetails.age;
    _phonecontroller.text = widget.studentdetails.phone;
    _placecontroller.text = widget.studentdetails.place;
    super.initState();
  }

  final GlobalKey<FormState> _keybottom = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade500,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: image1 != null
                            ? FileImage(image1!)
                            : FileImage(File(widget.studentdetails.image)),
                      ),
                      Positioned(
                        child: IconButton(
                            onPressed: () {
                              option();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                            )),
                        bottom: -8,
                        left: 40,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _keybottom,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 300,
                            child: TextFormField(
                              controller: _namecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 300,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                              ],
                              controller: _agecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter age';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.date_range),
                                border: OutlineInputBorder(),
                                labelText: 'Age',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 300,
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.phone,
                              controller: _phonecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(),
                                labelText: 'Phone no',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 300,
                            child: TextFormField(
                              controller: _placecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter place';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.place),
                                border: OutlineInputBorder(),
                                labelText: 'place',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                                onPressed: () {
                                  update(context, widget.studentdetails.id);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade500),
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Colors.black),
                                )),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> update(ctx, id) async {
    final _name = _namecontroller.text.trim();
    final _age = _agecontroller.text.trim();
    final _phone = _phonecontroller.text.trim();
    final _place = _placecontroller.text.trim();

    if (_keybottom.currentState!.validate()) {
      await updatestudent(
        id,
        _name,
        _age,
        _phone,
        _place,
        image!,
      );
      clearcontroller();
      Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
        return Homescreen();
      }));
      final _messege = 'Updated';
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
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
  }

  Future<void> fromgallery() async {
    final img1 = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img1 != null) {
      setState(() {
        image1 = File(img1.path);
        image = image1!.path;
      });
    }
  }

  Future<void> fromcamera() async {
    final img1 = await ImagePicker().pickImage(source: ImageSource.camera);

    if (img1 != null) {
      setState(() {
        image1 = File(img1.path);
        image = image1!.path;
      });
    }
    Navigator.of(context).pop();
  }

  option() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          content: Text(
            'Photo options',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  fromcamera();
                },
                child: Text(
                  'Camera',
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
              onPressed: () {
                fromgallery();
              },
              child: Text(
                'Gallery',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
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
