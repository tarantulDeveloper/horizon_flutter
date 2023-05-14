import 'package:example/api/base_api.dart';
import 'package:example/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Caught error: ${details.exception}');
    print('Stack trace:\n${details.stack}');
  };
  runApp(const HorizonApp());
}

class HorizonApp extends StatelessWidget {
  const HorizonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BaseApi>(
            create: (_) => BaseApi(), dispose: (_, api) => api.dio.close())
      ],
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
