import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
      const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

final textPro = StateProvider((ref) =>"");


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showFirst = true;

  void _change(){
    print("aaa");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Visibility(child: MyTextField(key: ValueKey(0)),visible: showFirst,maintainState: true,) , // ←　修正！
            MyTextField(key: ValueKey(1)), // ←　修正！
            MyTextField(key: ValueKey(2)), // ←　修正！
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState((){
            showFirst = !showFirst;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  MyTextField({Key? key}) : super(key: key);
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final controller = TextEditingController();// 　追加！
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(_change);
    print("a");

  }
   _change(){
      print(controller.text);
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}



