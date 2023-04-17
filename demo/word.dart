import 'package:flutter/material.dart';
// import 'package:my_app/pages/home/home.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const EnglishWordApp());
}

class EnglishWordApp extends StatelessWidget {
  const EnglishWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Placeholder(color: Colors.white);
    return ChangeNotifierProvider(
      create: (context) => EnglishWordAppState(),
      child: MaterialApp(
        title: "Name app",
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
        home: const MyHomePage(),
      ),
    );
  }
}

class EnglishWordAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavoriate() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  // @override
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = const FavoriatesPage();
        break;
      default:
        throw UnimplementedError('no widget $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              destinations: [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: const Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite), label: const Text('Favorites'))
              ],
              extended: constraints.maxWidth > 680,
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });

                print(
                  'selected value ${value} ${selectedIndex}',
                );
              },
            ),
          ),
          Expanded(
              child: SafeArea(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
              // color: Theme.of(context).colorScheme.primaryContainer
            ),
          ))
        ],
      ));
    });
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<EnglishWordAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        BigCard(pair: pair),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => {appState.toggleFavoriate()},
              icon: Icon(icon),
              label: const Text('Like'),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () => {appState.getNext()},
              child: const Text('Next'),
            ),
          ],
        )
      ]),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onSurface,
      fontWeight: FontWeight.bold,
    );
    return Card(
      elevation: 10,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoriatesPage extends StatelessWidget {
  const FavoriatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<EnglishWordAppState>();

    if (appState.favorites.isEmpty) {
      return const Center(
        child: Text(
          'No favoriates yet.',
        ),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ${appState.favorites.length} favoriates:',
          ),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          )
      ],
    );
  }
}
