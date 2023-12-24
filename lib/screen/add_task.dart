import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebas() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('myTasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          'New Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide()),
                  labelText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide()),
                  labelText: 'Description'),
            ),
            SizedBox(height: 30),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () {
                      addTaskToFirebas();
                    },
                    child: Text(
                      'Add Task',
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }
}
