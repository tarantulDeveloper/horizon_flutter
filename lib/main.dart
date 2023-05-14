import 'package:example/api/base_api.dart';
import 'package:example/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Caught error: ${details.exception}');
    print('Stack trace:\n${details.stack}');
  };
  runApp(HorizonApp());
}

class HorizonApp extends StatelessWidget {
  // const HorizonApp({Key? key}) : super(key: key);
  final BaseApi baseApi = BaseApi();

  HorizonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => baseApi,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "My Horizon App",
          theme: ThemeData(primarySwatch: Colors.teal),
          home: Scaffold(
            appBar: AppBar(
                centerTitle: true, title: const Text('Horizon Builders')),
            body: const LoginPage(),
          )),
    );
  }
}
