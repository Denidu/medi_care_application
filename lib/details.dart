import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart%20';

class Patient {
  final String yourName;
  final String phone;
  final String email;
  final String address;

  const Patient({
    required this.yourName,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
        yourName: json['YourName'],
        phone: json['Phone'],
        email: json['Email'],
        address: json['Address']);
  }
}

class PatientForNotifier extends ChangeNotifier {
  final TextEditingController userNameController =
      TextEditingController(text: '');
  final TextEditingController userPhoneController =
      TextEditingController(text: '');
  final TextEditingController userEmailController =
      TextEditingController(text: '');
  final TextEditingController userAddressController =
      TextEditingController(text: '');

  Future<void> savePatient() async {
    final patient = Patient(
      yourName: userNameController.text,
      phone: userPhoneController.text,
      email: userEmailController.text,
      address: userAddressController.text,
    );

    final response = await http.post(
      Uri.parse('https:medi.bto.bistecglobal.com/api/savePatient'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      print('Success: Patient Saved');
    } else {
      throw Exception('Faild to create patient');
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    userPhoneController.dispose();
    userEmailController.dispose();
    userAddressController.dispose();
    super.dispose();
  }
}

final patientFormProvider =
    ChangeNotifierProvider((ref) => patientFormProvider());

class Questions extends StatelessWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bistec Care'),
      ),
      body: Consumer(builder: (context, watch, _) {
        final patientForm = watch(patientFormProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: const Text(
                'Let us Know about You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }
}
