import 'dart:convert';

import 'package:english_words/english_words.dart';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromJson(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Client {

  int id;
  //WordPair wordPair;
  String wordPair;

  Client({
    this.id,
    this.wordPair
  });

  factory Client.fromJson(Map<String, dynamic> json) => new Client(
    id: json["id"],
    wordPair: json["word_pair"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "word_pair": wordPair
  };


}