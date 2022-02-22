import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
  runApp(
      const ProviderScope(
          child:  MyApp())
  );
}


final counterProvider = StateProvider((ref) {
  return 0;
});

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
      home:const Home()
    );
  }
}

class Home extends ConsumerWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('${ref.watch(counterProvider.state).state}'),
        ),
        
      ),floatingActionButton: FloatingActionButton(
      onPressed:()=> ref.read(counterProvider.state).state++,
    ),
    );
  }
}