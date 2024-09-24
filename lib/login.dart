import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terserah_kalian/home.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: no_logic_in_create_state
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  var username;
  var token;

  void _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
  }

  void _generateToken(){
    String generateRandomString(int length) {
      const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      final random = Random();
      return String.fromCharCodes(Iterable.generate(
        length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    }

    token = generateRandomString(6);
  }

  _showInput(controller, placeholder, isPassword) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),  
      ),
      obscureText: isPassword,
    ));
  }

  _showDialog(message, address){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => address));
              },
            )
          ],
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _generateToken();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(

        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Username", style: TextStyle(fontSize: 15)),
            ),
            _showInput(_usernameController, 'Masukkan Username', false),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Password", style: TextStyle(fontSize: 15)),
            ),
            _showInput(_passwordController, 'Masukkan Password', true),
            _showInput(_tokenController, 'Masukkan Token Dibawah', false),
            Text('Token: $token'),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (_usernameController.text == 'admin' &&
                      _passwordController.text == 'admin' &&
                      _tokenController.text == token) {
                    _saveUsername();
                    _showDialog('Login Successful', const HomePage());
                  } else {
                    _showDialog('Login Failed', const LoginPage());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
