import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/pages/login_page.dart';
import 'package:note_app/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _noteController = TextEditingController();

  void logout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'login');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: 'basic_channel',
        title: 'Logout Successful',
      ),
    );
  }

  void addBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Center(child: Text('Add Note')),
            content: TextFormField(
              controller: _noteController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: 'Enter your note',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _noteController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirestoreService().addNote(
                    _noteController.text,
                    FirebaseAuth.instance.currentUser!.uid,
                  );
                  Navigator.pop(context);
                  _noteController.clear();
                },
                child: const Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }

  void editBox(String currentNote, String docID) {
    _noteController.text = currentNote;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Center(child: Text('Edit Note')),
            content: TextFormField(
              controller: _noteController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: 'Edit your note',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _noteController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirestoreService().updateNote(
                    docID,
                    _noteController.text,
                  );
                  Navigator.pop(context);
                  _noteController.clear();
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${snapshot.data?.email}'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () => logout(context),
                ),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().getNotes(snapshot.data!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List notes = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = notes[index];
                      String docID = document.id;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String note = data['note'];

                      return ListTile(
                        title: Text(note),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit',
                              onPressed: () {
                                editBox(note, docID);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete',
                              onPressed: () async {
                                await FirestoreService().deleteNote(docID);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Your notes is empty'));
                }
              },
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: addBox,
              backgroundColor: Colors.black,
              child: const Icon(Icons.note_add, color: Colors.white),
            ),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
