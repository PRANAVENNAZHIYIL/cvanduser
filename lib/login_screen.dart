import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv_application/details.dart';
import 'package:cv_application/widgets/textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String url = "";
  int? number;
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobilenumber = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Textfield(
                controller: _firstNameController,
                label: "firstName",
                hint: "Enter your firstname",
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const Divider(
                height: 15,
              ),
              Textfield(
                label: "LastName",
                controller: _lastNameController,
                hint: "Enter your lastname",
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const Divider(
                height: 15,
              ),
              Textfield(
                label: "email",
                controller: _emailController,
                hint: "Enter your email address",
                validator: (value) {
                  const pattern =
                      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
                  final regex = RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Please enter your email adress';
                  } else if (!regex.hasMatch(value)) {
                    return 'Please enter a valid mail';
                  }
                  return null;
                },
              ),
              const Divider(
                height: 15,
              ),
              Textfield(
                  label: "Mobile Number",
                  controller: _mobilenumber,
                  hint: "Enter your mobile number",
                  validator: (value) {
                    const pattern = r'^[0-9]{10}$';
                    final regex = RegExp(pattern);
                    if (value!.isEmpty) {
                      return 'Mobile number is required';
                    } else if (!regex.hasMatch(value)) {
                      return 'Please enter a valid 10-digit mobile number';
                    }

                    return null;
                  }),
              const Divider(
                height: 15,
              ),
              Textfield(
                  label: "Date Of Birth",
                  controller: _dobController,
                  hint: "Enter your DOB",
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectedDate = (await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now()))!;
                    _dobController.text =
                        "${_selectedDate.toLocal()}".split(' ')[0];
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    final selectedDate = DateTime.parse(value);
                    final currentDate = DateTime.now();
                    final minDate =
                        currentDate.subtract(const Duration(days: 365 * 18));

                    if (selectedDate.isAfter(currentDate)) {
                      return 'Selected date is in the future';
                    } else if (selectedDate.isAfter(minDate)) {
                      return 'Must be at least 18 years old';
                    }

                    return null; // Return null if validation succeeds
                  }),
              const Divider(
                height: 15,
              ),
              ElevatedButton(
                onPressed: pickfile,
                child: const Text('Select CV And Upload'),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(
                height: 16.0,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addFirebase();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> uploadpdf(String filename, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("pdfs/$filename.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = reference.getDownloadURL();

    return downloadLink;
  }

  void pickfile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadpdf(fileName, file);

      await user.add({'name': fileName, 'downloadLink': downloadLink});
    }
  }

  void addFirebase() async {
    final firstname = _firstNameController.text;
    final lastname = _lastNameController.text;
    final dob = _dobController.text;
    final mobile = _mobilenumber.text;
    final email = _emailController.text;

    final data = {
      'firstname': firstname,
      'lastname': lastname,
      'dob': dob,
      'mobile': mobile,
      'email': email,
    };

    user.add(data);
  }
}
