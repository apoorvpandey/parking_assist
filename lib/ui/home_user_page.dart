import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_assist/ui/parking_slot_grid.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: fetchParkingSlotsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ParkingSlotsGrid(slotsData: snapshot.data!);
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> fetchParkingSlotsData() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('parkingSlots').get();
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data;
    }
    return null;
  }
}
