import 'package:flutter/material.dart';

import 'booking.dart';

class uploadPrescription extends StatefulWidget {
  final String location;
  const uploadPrescription({super.key, required this.location});

  @override
  State<uploadPrescription> createState() => _uploadPrescriptionState();
}

class _uploadPrescriptionState extends State<uploadPrescription> {
  String place = '';
  @override
  void initState() {
    super.initState();
    place = widget.location;
  }

  void _booking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Booking(location: place)),
    );
  }

  void camera() {
    Navigator.pushNamed(context, '/camera');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
