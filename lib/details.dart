import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv_application/pdfviewer.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String first = data['firstname'] ?? "";
              String name = data['lastname'] ?? "";
              String dob = data['dob'] ?? "";
              String mob = data['mobile'] ?? "";
              String pdfname = data['name'] ?? "";
              String pdflink = data['downloadLink'] ?? "";

              return Column(
                children: [
                  Text(
                    "First Name :$first",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Last Name :$name",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "dob:$dob",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "mobile:$mob",
                    style: const TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PdfViewer(pdfUrl: pdflink)));
                    },
                    child: Text(
                      "pdf:$pdfname",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
