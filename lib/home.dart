import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tempahanbilikadmin/kalendartempahan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<String> options = <String>['Delete', 'Update'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senarai Tempahan'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const ListTile(
              title: Text('Home'),
            ),
            ListTile(
              title: const Text('Kalendar'),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => const KalendarTempahan());
                Navigator.push(context, route);
              },
            ),
            const ListTile(
              title: Text('Logout'),
            )
          ],
        ),
      ),
      body: FutureBuilder(
          future: firestore.collection('tempahan').get(),
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading:
                          Image.asset('images/${data['photo'].toString()}.jpg'),
                      title: Text(data['name'].toString()),
                      subtitle:
                          Text('( ${data['mula']} hingga ${data['tamat']} )'),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.settings),
                        itemBuilder: (BuildContext context) =>
                            options.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList(),
                        onSelected: (String value) {
                          if (value == "Delete") {
                            print(document.id);
                            try {
                              firestore
                                  .collection('tempahan')
                                  .doc(document.id)
                                  .delete();
                              setState(() {
                                //update screen
                              });
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          } else if (value == "Update") {
                            try {
                              firestore
                                  .collection('tempahan')
                                  .doc(document.id)
                                  .update({'status': 'lulus'});
                              setState(() {
                                //refresh screen
                              });
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          }
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
