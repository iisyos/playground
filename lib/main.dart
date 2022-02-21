import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(const MyApp());
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
      home: Boxes(),
    );
  }
}

class Box extends StatelessWidget {
  const Box({Key? key,required this.color}) : super(key: key);
  final  Color color;

  @override
  Widget build(BuildContext context) {
    return  Expanded(child: AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        color: color,
      ) ,
    )
    );
  }
}


class Boxes extends StatefulWidget {
  const Boxes({Key? key}) : super(key: key);

  @override
  _BoxesState createState() => _BoxesState();
}

class Boxstful extends StatefulWidget {
  const Boxstful({Key? key,required this.color}) : super(key: key);
  final Color color;

  @override
  _BoxstfulState createState() => _BoxstfulState();
}

class _BoxstfulState extends State<Boxstful> {
  @override
  Widget build(BuildContext context) {
    return   Expanded(child: AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        color: widget.color,
      ) ,
    )
    );
  }
}

class StatelessColorfulTile extends StatelessWidget {
  final Color _color = UniqueColorGenerator.getColor();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: _color, child: Padding(padding: EdgeInsets.all(100.0)));
  }
}

class UniqueColorGenerator {
  static List _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.indigo,
    Colors.amber,
    Colors.black,
  ];
  static Random _random = new Random();
  static Color getColor() {
    if (_colorOptions.length > 0)
      return _colorOptions.removeAt(_random.nextInt(_colorOptions.length));
    else
      return Color.fromARGB(_random.nextInt(256), _random.nextInt(256),
          _random.nextInt(256), _random.nextInt(256));
  }
}



class StatefulColorfulTile extends StatefulWidget {
  StatefulColorfulTile({Key? key}) : super(key: key);

  @override
  ColorfulTileState createState() => ColorfulTileState();
}

class ColorfulTileState extends State<StatefulColorfulTile> {
  Color? _color;
  @override
  void initState() {
    super.initState();
    _color = UniqueColorGenerator.getColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: _color,
        child: Padding(
          padding: EdgeInsets.all(100.0),
        ));
  }
}
class _BoxesState extends State<Boxes> {
  final List<Widget> _boxes=[
    StatefulColorfulTile(key: UniqueKey()), // 変更！！
    StatefulColorfulTile(key: UniqueKey()),
  ];
  void _swapTiles() {
    setState(() {
      _boxes.insert(1, _boxes.removeAt(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: _boxes,
      ),floatingActionButton: FloatingActionButton(
      onPressed: (){
        _swapTiles();
        // setState(() {
        //   _boxes.shuffle();
        // });
      },
    ),appBar: AppBar(

    ),
    );
  }
}
