import 'package:flutter/material.dart';
import 'package:parking_assist/ui/parking_slot_widget.dart';

class ParkingSlotsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> slotsData;

  const ParkingSlotsGrid({super.key, required this.slotsData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: slotsData.length,
      itemBuilder: (context, index) {
        final available = slotsData[index]['available'] as bool;
        final slotNumber = slotsData[index]['number'] as int;
        return ParkingSlotWidget(available: available, slotNumber: slotNumber);
      },
    );
  }
}
