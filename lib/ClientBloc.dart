import 'dart:async';

import 'ClientModel.dart';
import 'DB.dart';

class ClientsBloc {
  ClientsBloc() {
    getClients();
  }
  final _clientController =  StreamController<List<Client>>.broadcast();
  get clients => _clientController.stream;

  dispose() {
    _clientController.close();
  }

  getClients() async {
    _clientController.sink.add(await DBProvider.db.getAllClients());
  }


  delete(String wordPair) {
    DBProvider.db.deleteClient(wordPair);
    getClients();
  }

  add(Client client) {
    DBProvider.db.newClient(client);
    getClients();
  }

  getAll(){
    return DBProvider.db.getAllClients();
  }

  Future<bool> contains(String wordPair){
    return DBProvider.db.contains(wordPair);
  }
}