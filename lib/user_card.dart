import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/edit_page.dart';
import 'package:contacts/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  UserCard(
      {Key? key, required this.name, required this.mobNo, required this.emailId, required this.delete,required this.Ename, required this.EmobNo, required this.EemailId})
      : super(key: key);
  final String name;
  final String mobNo;
  final String emailId;
  final String Ename;
  final String EmobNo;
  final String EemailId;
  final String delete;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  void deleteContact(String documentId) {
    FirebaseFirestore.instance.collection('Contacts').doc(documentId).delete()
        .then((value) {
      print('Contact deleted successfully.');
    })
        .catchError((error) {
      print('Failed to delete contact: $error');
    });
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 0.2*screenSize.width,
                  child: Image.asset('assets/avatar.png'),
                ),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 0.6*screenSize.width,child: Text(widget.name, style: const TextStyle(fontSize: 20),), ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Mobile No. : ${widget.mobNo}'),
                    const SizedBox(height: 10,),
                    Text('Email Id : ${widget.emailId}'),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(onPressed: (){ deleteContact(widget.delete);}, child: const Icon(Icons.delete),),
                        SizedBox(width: 30),
                        ElevatedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(editName: widget.Ename, editMob: widget.EmobNo, editEmail: widget.EemailId,),),);
                        }, child: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
