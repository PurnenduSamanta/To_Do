import 'package:flutter/material.dart';
import 'package:todo/screen/add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = 'empty';
  @override
  void initState() {
    getUID();
    super.initState();
  }

  getUID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('myTasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                final docs = snapshot.data?.docs;
                return ListView.builder(
                  itemCount: docs?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.lightGreenAccent,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsetsDirectional.all(10),
                      height: 90,
                      child: Column(
                        children: [Text(docs?[index]['title'])],
                      ),
                    );
                  },
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
