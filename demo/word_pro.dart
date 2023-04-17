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
        title: "Namer app",
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
  var favorites = <WordPair>[];
  var history = <WordPair>[];

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  GlobalKey? historyListKey;

  void toggleFavorite(WordPair? pair) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
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
    var colorTheme = Theme.of(context).colorScheme;
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

    var mainArea = ColoredBox(
      color: colorTheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Column(
            children: [
              Expanded(child: mainArea),
              // Spacer(),
              BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite), label: 'Favorite'),
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              )
            ],
          );
        }
        return Scaffold(
            body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: const Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: const Text('Favorites'))
                ],
                extended: constraints.maxWidth > 600,
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
                // child: page,
                child: mainArea,
                // color: Theme.of(context).colorScheme.primaryContainer
              ),
            ))
          ],
        ));
      }),
    );
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
        const Expanded(
          child: const HistoryListView(),
          flex: 3,
        ),
        const SizedBox(
          height: 10,
        ),
        BigCard(pair: pair),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => {appState.toggleFavorite(null)},
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
        ),
        const Spacer(flex: 2),
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
        // child: Text(
        //   pair.asLowerCase,
        //   style: style,
        //   semanticsLabel: "${pair.first} ${pair.second}",
        // ),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: MergeSemantics(
              child: Wrap(
            children: [
              Text(
                pair.first,
                style: style.copyWith(fontWeight: FontWeight.w200),
              ),
              Text(
                pair.second,
                style: style.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          )),
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
    var theme = Theme.of(context);
    if (appState.favorites.isEmpty) {
      return const Card(
        child: Center(
          child: Text(
            'No favoriates yet.',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<EnglishWordAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: const EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
                child: TextButton.icon(
              onPressed: () {
                appState.toggleFavorite(pair);
              },
              icon: appState.favorites.contains(pair)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              label: Text(
                pair.asLowerCase,
                semanticsLabel: pair.asPascalCase,
              ),
            )),
          );
        },
      ),
    );

    return const Placeholder();
  }
}
