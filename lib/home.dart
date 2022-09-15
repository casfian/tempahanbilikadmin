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

  final List<String> options = <String>['Padam', 'Lulus', 'Pinda'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senarai Tempahan'),
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => const Home());
                Navigator.push(context, route);
              },
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
      body: StreamBuilder(
          stream: firestore.collection('tempahan').snapshots(),
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
                      //leading: Text(data['status'].toString()),
                      title: Text(data['name'].toString()),
                      subtitle:
                          Text('Status: ${data['status']},\n( ${data['mula']} hingga ${data['tamat']} )'),
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
                          if (value == "Padam") {
                            debugPrint(document.id);
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
                          } else if (value == "Lulus") {
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
                          } else if (value == "Pinda") {

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
