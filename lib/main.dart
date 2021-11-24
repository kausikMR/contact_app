import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<PermissionStatus>(
        stream: Permission.contacts.status.asStream(),
        builder: (context, AsyncSnapshot<PermissionStatus> snap) {
          if (snap.hasData) {
            if (snap.data == PermissionStatus.granted) {
              return const ContactsListPage();
            } else {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Permission.contacts.request();
                    },
                    child: const Text("Grant Permission"),
                  ),
                ),
              );
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Contact>>(
          future: getContacts(),
          builder: (BuildContext context, AsyncSnapshot<List<Contact>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasData) {
              var contacts = snap.data!;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(contacts[index].displayName.toString()),
                  );
                },
              );
            }
            return const Center(
              child: Text("Some error occured"),
            );
          },
        ),
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    var fetchedContacts = await ContactsService.getContacts();
    contacts.addAll(fetchedContacts);
    return contacts;
  }
}
