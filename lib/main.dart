import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_test_app1/ClientBloc.dart';
import 'package:flutter_test_app1/ClientModel.dart';

import 'DB.dart';

import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: RandomWords(),
    );
  }
}


class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _clientBloc = ClientsBloc();
  int counter = 0;

  Widget _buildRow(WordPair wordPair) {
    String pair = wordPair.asPascalCase;

    return FutureBuilder<bool>(
        future: _clientBloc.contains(pair),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          final bool alreadySaved = snapshot.hasData ? snapshot.data : false;

          return ListTile(
            title: Text(
              pair,
              style: _biggerFont,
            ),

            trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
            ),

            onTap: (){
              setState(() {
                if(alreadySaved)
                  _clientBloc.delete(pair);
                else{
                  _clientBloc.add(clientFromJson(
                      "{"
                          "\"id\": " + pair.hashCode.toString() + ", "
                          "\"word_pair\": \"" + pair + "\" "
                          "}"
                          "")
                  );
                }
              });
            },
          );
      }
    );

  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {

          return SavedWords(
              _clientBloc,
                  () =>
                      setState((){})
          );
        },
      ),
    );
  }
}

class SavedWords extends StatefulWidget{

  final ClientsBloc _bloc;
  //final Set<Client> _saved;
  final Function() onRemove;

  const SavedWords(this._bloc, this.onRemove);

  @override
  _SavedWordsState createState() => _SavedWordsState();
}

class _SavedWordsState extends State<SavedWords>
{
  //final Set<WordPair> _saved;
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: Text('Saved Suggestions'),
    ),
    body: //ListView(children: divided),
      FutureBuilder<List<Client>>(
        future: DBProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Client item = snapshot.data[index];
                return ListTile(
                  title: Text(
                      item.wordPair,
                      style: _biggerFont,
                  ),
                  //leading: Text(item.id.toString()),
                  onTap: () => _showRemoveDialog(item),
                );
              },
            );
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        }

      )
    );
  }

  Future<void> _showRemoveDialog(Client client) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove'),
          content: SingleChildScrollView(
            child: Text("Are you sure you want to remove this name?"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Remove'),
              onPressed: () {
                widget.onRemove();
                setState(() {
                  widget._bloc.delete(client.wordPair);
                });

                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
