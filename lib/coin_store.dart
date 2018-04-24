import 'dart:async';

import 'package:cryptocurrency_tracker/data/coin.dart';
import 'package:cryptocurrency_tracker/data/coin_repository.dart';
import 'package:flutter_flux/flutter_flux.dart';

class CoinStore extends Store {
  final List<Coin> _coins = <Coin>[];
  final CoinRepository _repository = CoinRepository();

  CoinStore() {
    triggerOnAction(actionGetCoins, (_) async {
      print("triggerOnAction start");
      Stream<Coin> streamCoins = await _repository.getAllCoins();
      _coins
        ..clear()
        ..addAll(await streamCoins.toList());
      print("triggerOnAction end");
    });
  }

  List<Coin> get coins => List<Coin>.unmodifiable(_coins);
}

final StoreToken coinStoreToken = StoreToken(CoinStore());
final Action actionGetCoins = Action();
