import 'package:flutter/material.dart';
import 'package:todo/screen/add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todo/screen/description.dart';

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
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
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
                    final date =
                        (docs?[index]['timestamp'] as Timestamp).toDate();
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Description(
                                    title: docs?[index]['title'],
                                    desc: docs?[index]['description'])));
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 33, 35, 30),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        docs?[index]['title'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(height: 3),
                                      Text(DateFormat.yMd()
                                          .add_jm()
                                          .format(date)),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('tasks')
                                          .doc(uid)
                                          .collection('myTasks')
                                          .doc(docs?[index]['time'])
                                          .delete();
                                    },
                                  )
                                ]),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
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
