import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FireStoreApp());
}

class FireStoreApp extends StatefulWidget {
  const FireStoreApp({Key? key}) : super(key: key);

  @override
  _FireStoreAppState createState() => _FireStoreAppState();
}

class _FireStoreAppState extends State<FireStoreApp> {
  // This list contains the bookmarked document ID's
  var bookmarklist = ["1RAgxufEWyFPjXcrURvo", "XEjBHIUBWENF15KQcYNc"];
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference groceries =
        FirebaseFirestore.instance.collection('groceries');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: textController,
          ),
        ),
        body: Center(
          child: StreamBuilder(
            stream: groceries.orderBy('name').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('loading'),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((grocery) {
                  // if (grocery.id == "1RAgxufEWyFPjXcrURvo") {
                  if (bookmarklist.contains(grocery.id)) {
                    // TO return just empty Stuffs
                    return Container();
                  }

                  return Center(
                    child: ListTile(
                      title: Text(grocery['name']),
                      onTap: () {
                        // The Document ID of the selected Document in bucket
                        print(grocery.id);
                      },
                      onLongPress: () {
                        grocery.reference.delete();
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            print('hi');
            groceries
                .add({'name': textController.text, 'age': textController.text});
            // groceries.add({});

            textController.clear();
          },
        ),
      ),
    );
  }
}
