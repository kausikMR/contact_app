import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactsListPage()
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
              var contacts = snap.data;
              return ListView.builder(
                itemCount: contacts!.length,
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
