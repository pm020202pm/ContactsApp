import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/user.dart';
import 'package:flutter/material.dart';
class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.editName, required this.editMob, required this.editEmail, }) : super(key: key);
  final String editName;
  final String editMob;
  final String editEmail;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _nameController;
  late TextEditingController _mobNoController;
  late TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.editName);
    _mobNoController = TextEditingController(text: widget.editMob);
    _emailController = TextEditingController(text: widget.editEmail);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobNoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void updateContact() {
    FirebaseFirestore.instance.collection('Contacts').doc(widget.editName).update({
      'Name': _nameController.text,
      'MobNo': _mobNoController.text,
      'EmailId': _emailController.text,
    }).then((value) {
      Navigator.pop(context); // Navigate back to the previous screen
    }).catchError((error) {
      // Handle error
      print('Failed to update contact: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _mobNoController,
              decoration: InputDecoration(labelText: 'Mob. No.'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: updateContact,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
