import 'dart:convert';

import 'package:example/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../api/base_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(
      {required String username,
      required String password,
      required NavigatorState navigator}) async {
    /*final url = Uri.parse('http://3.34.2.208:5000/api/authenticate');
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password
      })
    );

    if(response.statusCode == 200) {
      print('Login successful!');
      print(jsonDecode(response.body.toString()));
    } else {
      print('Login failed! Error: ${response.body}');
    }*/

    final baseApi = Provider.of<BaseApi>(context, listen: false);
    final url = Uri.parse('${baseApi.getBaseUrl()}/authenticate');
    final response = await baseApi.dio.post(url.toString(),
        data: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => WelcomePage(
              accessToken: accessToken, refreshToken: refreshToken)));
    } else {
      print('Login failed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Login Page',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.teal),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email)),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.remove_red_eye)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {}, child: const Text("Forget Password?"))
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.green])),
                  child: MaterialButton(
                    onPressed: () {
                      final username = usernameController.text.toString();
                      final password = passwordController.text.toString();
                      _login(
                          username: username,
                          password: password,
                          navigator: Navigator.of(context));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Icon(
                  Icons.fingerprint,
                  color: Colors.teal,
                  size: 60,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Divider(
                  height: 5,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text('Register Account'))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
