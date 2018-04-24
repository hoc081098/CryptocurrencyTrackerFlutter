class Coin {
  String id, name, symbol;
  int rank, lastUpdated;
  double priceUsd, priceBtc, percentChange1h, percentChange24h, percentChange7d;

  Coin({
    this.id,
    this.name,
    this.symbol,
    this.rank,
    this.lastUpdated,
    this.priceUsd,
    this.priceBtc,
    this.percentChange1h,
    this.percentChange24h,
    this.percentChange7d,
  });

  Coin.fromJson(Map map)
      : id = map['id'],
        name = map['name'],
        symbol = map['symbol'],
        rank = int.parse(map['rank']),
        lastUpdated = int.parse(map['last_updated']),
        priceUsd = double.parse(map['price_usd']),
        priceBtc = double.parse(map['price_btc']),
        percentChange1h = double.parse(map['percent_change_1h']),
        percentChange24h = double.parse(map['percent_change_24h']),
        percentChange7d = double.parse(map['percent_change_7d']);
}
