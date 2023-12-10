import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String title, desc;
  const Description({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Description')),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 3),
            Text(desc)
          ],
        ),
      ),
    );
  }
}
