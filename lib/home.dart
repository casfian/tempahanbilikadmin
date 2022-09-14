import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  Home({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempahan Saya'),
      ),
      body: FutureBuilder(
          future: firestore
              .collection('tempahan')
              .get(),
          builder: (context, snapshot) {
            //check error here
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            //---

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return ListTile(
                  leading: Text(data['status'].toString()),
                  title: Text(data['name'].toString()),

                  trailing: TextButton(
                    onPressed: () {
                      //code
                    },
                    child: const Text('Update'),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
