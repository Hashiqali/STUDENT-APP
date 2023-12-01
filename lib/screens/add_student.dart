import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_student/db/function/db_function.dart';
import 'package:sqflite_student/db/model/db_model.dart';

File? image1;
String? image;

class Studentadd extends StatefulWidget {
  const Studentadd({super.key});

  @override
  State<Studentadd> createState() => _StudentaddState();
}

class _StudentaddState extends State<Studentadd> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final _namecontroller = TextEditingController();

  final _agecontroller = TextEditingController();

  final _phonecontroller = TextEditingController();

  final _placecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(21),
          child: Text(
            'Please Enter Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.amber.shade500,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: image1 != null
                                ? FileImage(image1!)
                                : const AssetImage('assets/images/images.jpeg')
                                    as ImageProvider,
                          ),
                          Positioned(
                            child: IconButton(
                                onPressed: () {
                                  option();
                                },
                                icon: const Icon(Icons.add_a_photo)),
                            bottom: -10,
                            right: -12,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 80,
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                          controller: _namecontroller,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              labelText: '   Name'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 80,
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter age';
                            }
                            return null;
                          },
                          controller: _agecontroller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2)
                          ],
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.date_range),
                              border: OutlineInputBorder(),
                              labelText: ' Age'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 80,
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                          controller: _phonecontroller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 80,
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter place';
                            }
                            return null;
                          },
                          controller: _placecontroller,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.place),
                              border: OutlineInputBorder(),
                              labelText: 'Place'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () {
                              addstudent(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade500),
                            child: const Text(
                              'Add studdent',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
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

  Future<void> fromgallery() async {
    final img1 = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img1 != null) {
      setState(() {
        image1 = File(img1.path);
        image = image1!.path;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future<void> fromcamera() async {
    final img1 = await ImagePicker().pickImage(source: ImageSource.camera);

    if (img1 != null) {
      setState(() {
        image1 = File(img1.path);
        image = image1!.path;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  option() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.amber.shade500,
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

  Future<void> addstudent(BuildContext context) async {
    final _name = _namecontroller.text.trim();
    final _age = _agecontroller.text.trim();
    final _phone = _phonecontroller.text.trim();
    final _place = _placecontroller.text.trim();

    if (_formkey.currentState!.validate() && image1 != null) {
      final _studentvalues = Studentmodel(
        name: _name,
        age: _age,
        phone: _phone,
        place: _place,
        image: image!,
      );
      await addstudent1(_studentvalues);
      await clearcontroller();
      Navigator.of(context).pop();

      final _messege = 'Submitted';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 232, 107, 99),
        margin: const EdgeInsets.all(50),
        content: Text(
          _messege,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
        ),
      ));
    } else {
      final _messege = 'Please add your photo';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 232, 107, 99),
        margin: const EdgeInsets.all(50),
        content: Text(
          _messege,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
        ),
      ));
    }
  }
}
