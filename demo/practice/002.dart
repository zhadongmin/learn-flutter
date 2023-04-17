import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      title: 'My app',
      home: SafeArea(
        child: TutorialHome(),
      )));
}

class TutorialHome extends StatelessWidget {
  const TutorialHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.menu,
          ),
          tooltip: 'Navigation menu',
        ),
        title: const Text('Example title'),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
      floatingActionButton: const FloatingActionButton(
        tooltip: 'add',
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );
  }
}
/**
 * 
 * https://docs.flutter.dev/development/ui/widgets-intro
 * 
 * Using Material Components
 * 
 * For more information, see [Material Components widgets.](https://docs.flutter.dev/development/ui/widgets/material)
 */