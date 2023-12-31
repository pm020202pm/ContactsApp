import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/user_card.dart';
import 'package:flutter/material.dart';

Future<List<QueryDocumentSnapshot>> fetchFirestoreDocuments() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Contacts').get();
  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  return documents;
}

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);
  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshAcceptedUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobNoController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  void newUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new contact'),
          content: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _mobNoController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile No.',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a mobile number';
                        } else if (!_isNumeric(value)) {
                          return 'Please enter a valid mobile number';
                        } else if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailIdController,
                      decoration: const InputDecoration(
                        labelText: 'Email Id',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        else if ((!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([a-z0-9-]+\.)+[a-z]{2,}$')
                            .hasMatch(value))) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()) {
                  _refreshAcceptedUsers();
                  await FirebaseFirestore.instance
                      .collection('Contacts')
                      .add({
                        'Name': _nameController.text,
                        'MobNo': _mobNoController.text,
                        'EmailId': _emailIdController.text,
                      })
                      .then((value) => print("User added"))
                      .catchError(
                          (error) => print("Failed to add user: $error"));
                  Navigator.pop(context);
                  _nameController.clear();
                  _mobNoController.clear();
                  _emailIdController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: RefreshIndicator(
          onRefresh: _refreshAcceptedUsers,
          child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: fetchFirestoreDocuments(),
            builder: (BuildContext context,
                AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              List<QueryDocumentSnapshot> documents = snapshot.data!;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  var contact = documents[index];
                  var name = documents[index].get('Name');
                  var mobNo = documents[index].get('MobNo');
                  var emailId = documents[index].get('EmailId');
                  return UserCard(
                    name: name,
                    mobNo: mobNo,
                    emailId: emailId,
                    delete: contact.id,
                    Ename: name,
                    EmobNo: mobNo,
                    EemailId: emailId,
                  );
                },
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: newUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
