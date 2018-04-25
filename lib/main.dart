import 'package:cryptocurrency_tracker/coin_store.dart';
import 'package:cryptocurrency_tracker/data/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:meta/meta.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptocurrency tracker',
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'assets/NunitoSans-Regular.ttf'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with StoreWatcherMixin<MyHomePage> {
  CoinStore _coinStore;

  @override
  void initState() {
    super.initState();
    _coinStore = listenToStore(coinStoreToken);
    actionGetCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptocurrency tracker'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: _coinStore.coins.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              _CoinWidget(currentCoin: _coinStore.coins[index]),
        ),
        onRefresh: () async => actionGetCoins(),
      ),
    );
  }
}

@immutable
class _CoinWidget extends StatelessWidget {
  final Coin currentCoin;

  const _CoinWidget({Key key, @required this.currentCoin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'assets/NunitoSans-Regular.ttf',
      fontSize: 14.0,
      color: Colors.lightBlueAccent.shade100,
      fontWeight: FontWeight.w400,
    );

    final dateTime =
    DateTime.fromMillisecondsSinceEpoch(currentCoin.lastUpdated * 1000);
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString().padLeft(4, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return ExpansionTile(
      initiallyExpanded: false,
      title: ListTile(
        leading: CircleAvatar(
          radius: 32.0,
          child: Image.network(
            "https://res.cloudinary.com/dxi90ksom/image/upload/${currentCoin
                .symbol}.png",
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
        ),
        title: Text(
          "${currentCoin.rank.toString().padLeft(2)} | ${currentCoin.symbol
              .padLeft(2, '0')}",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.tealAccent.shade700,
          ),
        ),
        subtitle: Text(
          currentCoin.name.toUpperCase(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Price btc: ${currentCoin.priceBtc.toStringAsFixed(4)}",
                style: textStyle,
              ),
              Text(
                "Price usd: \$${currentCoin.priceUsd.toStringAsFixed(4)}",
                style: textStyle,
              ),
              Text(
                "1 hour: ${currentCoin.percentChange1h
                    .toStringAsFixed(4)}%",
                style: textStyle.copyWith(
                    color: currentCoin.percentChange1h < 0
                        ? Colors.redAccent.shade400
                        : Colors.greenAccent.shade400),
              ),
              Text(
                "24 hours: ${currentCoin.percentChange24h
                    .toStringAsFixed(4)}%",
                style: textStyle.copyWith(
                    color: currentCoin.percentChange24h < 0
                        ? Colors.redAccent.shade400
                        : Colors.greenAccent.shade400),
              ),
              Text(
                "7 days: ${currentCoin.percentChange7d
                    .toStringAsFixed(4)}%",
                style: textStyle.copyWith(
                    color: currentCoin.percentChange7d < 0
                        ? Colors.redAccent.shade400
                        : Colors.greenAccent.shade400),
              ),
              Text(
                "Last updated: $hour:$minute, $day/$month/$year",
                style: textStyle.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        )
      ],
    );
  }
}
