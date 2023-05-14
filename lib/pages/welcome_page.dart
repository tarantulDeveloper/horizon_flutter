import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key, required this.accessToken, required this.refreshToken}) : super(key: key);
  final String accessToken;
  final String refreshToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Page"),
      ),
      body: Center(
        child: Column(
          children: [
            Text('access token: $accessToken'),
            const SizedBox(height: 30),
            Text('refresh token: $refreshToken')
          ],
        ),
      ),
    );
  }
}