import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParkingSlotWidget extends StatelessWidget {
  final bool available;
  final int slotNumber;

  const ParkingSlotWidget(
      {super.key, required this.available, required this.slotNumber});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopup(context),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: available ? Colors.green : Colors.red,
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            slotNumber.toString(),
            style: const TextStyle(
              color: Colors.white, // Text color
              fontWeight: FontWeight.bold, // Text style
            ),
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String enteredMobile = '';
        String enteredName = '';

        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Enter Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Mobile'),
                  onChanged: (value) {
                    enteredMobile = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    enteredName = value;
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateParkingSlot(enteredName, enteredMobile);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateParkingSlot(String name, String mobile) async {
    final collectionRef = FirebaseFirestore.instance.collection('parkingSlots');
    final querySnapshot =
        await collectionRef.where('number', isEqualTo: slotNumber).get();
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await collectionRef.doc(docId).update({
        'name': name,
        'mobile': mobile,
        'available': false,
      });
    }
  }
}
