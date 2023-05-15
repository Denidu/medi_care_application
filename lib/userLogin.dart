import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dashBoard.dart';

class UserCredentials {
  final String username;
  final String password;

  const UserCredentials({required this.username, required this.password});

  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      username: json['username'],
      password: json['password'],
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userPassController = TextEditingController();

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://medi.bto.bistecglobal.com/api/Function1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(value: _userIdController.text),
        ),
      );
    } else {
      throw Exception('Faild to create.');
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _userPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: [
            Container(
                color: Colors.white,
                width: double.infinity,
                height: 470.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Log into Your Account",
                      style: TextStyle(
                          color: Color.fromARGB(255, 28, 146, 243),
                          fontSize: 15.0),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: TextField(
                        controller: _userIdController,
                        style: const TextStyle(fontSize: 20.0),
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text("Forgot Password",
                              style: TextStyle(fontSize: 15.0)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 50, right: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFF2196F3),
                      ),
                      child: TextButton(
                        onPressed: () {
                          login(
                              _userIdController.text, _userPassController.text);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Dont't have an accout?"),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Sign up here",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
