import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      title: 'My app',
      home: SafeArea(
        child: MyScaffold(),
      )));
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue[500]),
      child: Row(children: [
        const IconButton(
          onPressed: null,
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
        ),
        Expanded(child: title),
        const IconButton(
          onPressed: null,
          icon: Icon(Icons.search),
          tooltip: 'Search',
        ),
      ]),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          MyAppBar(
            title: Text('Hello World',
                style: Theme.of(context).primaryTextTheme.titleLarge),
          )
        ],
      ),
    );
  }
}
/**
 * Text
 * Container
 * Row Column
 * Stack
 * 
 * Material Design
 * 
 * https://docs.flutter.dev/development/ui/widgets-intro
 * 
 * Basic widgets
 * 
 * For more information, see [Layouts](https://docs.flutter.dev/development/ui/widgets/layout).


 */