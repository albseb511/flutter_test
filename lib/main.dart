import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build( BuildContext context){
    return MaterialApp(
      title: "NAME GEN",
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({ Key? key }) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = <WordPair>{};

  Widget _buildRow( WordPair pair ){
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite: Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }
          else{
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder:  (context, i){
        if(i.isOdd) return const Divider();

        final index = i ~/ 2;
        if( index >= _suggestions.length){
          _suggestions.addAll(
            generateWordPairs().take(10)
          );
        }
        return _buildRow( _suggestions[index] );
      },
    );
  }
  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final tiles = _saved.map(
            (WordPair pair){
              return ListTile( 
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont
                )
              );
            }
          );
          final divided = tiles.isNotEmpty ?
          ListTile.divideTiles(tiles: tiles,context:context).toList():<Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: Text("Saved Suggestions")
            ),
            body: ListView(children: divided)
          );
        }
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Name generator"),
        actions:[
          IconButton(icon:const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}