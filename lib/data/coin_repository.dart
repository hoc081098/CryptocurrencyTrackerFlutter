import 'dart:async';
import 'dart:convert';

import 'package:cryptocurrency_tracker/data/coin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class CoinRepository {
  static CoinRepository _instance;

  factory CoinRepository() => _instance ??= CoinRepository._internal();

  CoinRepository._internal();

  Future<Stream<Coin>> getAllCoins() async {
    var url = 'https://api.coinmarketcap.com/v1/ticker/';
    var client = http.Client();
    var streamRes = await client.send(http.Request('get', Uri.parse(url)));
    return streamRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((json) => json as List)
        .map((json) => Coin.fromJson(json));
  }
}
