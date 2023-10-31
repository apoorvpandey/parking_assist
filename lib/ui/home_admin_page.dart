import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  HomeAdminPageState createState() => HomeAdminPageState();
}

class HomeAdminPageState extends State<HomeAdminPage> {
  int parkingSlots = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enter the number of parking slots default is 5:',
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    parkingSlots = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addItemsToFireStore();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addItemsToFireStore() async {
    final collectionRef = FirebaseFirestore.instance.collection('parkingSlots');
    final now = DateTime.now();
    final formatter = DateFormat('dd:MM:yyyy HH:mm:ss.SSS');
    final formattedDate = formatter.format(now);

    for (int i = 1; i <= parkingSlots; i++) {
      final randomId = 'parking_slot_$formattedDate$i';
      final itemData = {
        'id': randomId,
        'number': i,
        'available': true,
        'mobile': '',
        'name': ''
      };

      await collectionRef.doc(randomId).set(itemData);
    }
  }
}
