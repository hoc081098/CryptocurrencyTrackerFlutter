import 'package:cryptocurrency_tracker/coin_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';

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
    final textStyle = TextStyle(
      fontFamily: 'assets/NunitoSans-Regular.ttf',
      fontSize: 14.0,
      color: Colors.lightBlueAccent.shade100,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptocurrency tracker'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: _coinStore.coins.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var currentCoin = _coinStore.coins[index];
            var dateTime = DateTime
                .fromMillisecondsSinceEpoch(currentCoin.lastUpdated * 1000);

            var day = dateTime.day.toString().padLeft(2, '0');
            var month = dateTime.month.toString().padLeft(2, '0');
            var year = dateTime.year.toString().padLeft(4, '0');

            var hour = dateTime.hour.toString().padLeft(2, '0');
            var minute = dateTime.minute.toString().padLeft(2, '0');

            return ExpansionTile(
              initiallyExpanded: false,
              title: ListTile(
                leading: CircleAvatar(
                  child: Image.network(
                    "https://res.cloudinary.com/dxi90ksom/image/upload/${currentCoin
                        .symbol}.png",
                    fit: BoxFit.cover,
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                ),
                title: Text(
                  currentCoin.rank.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  "${currentCoin.symbol.padLeft(2, '0')} | ${currentCoin.name}"
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.0,
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
                        "Price usd: ${currentCoin.priceUsd.toStringAsFixed(4)}",
                        style: textStyle,
                      ),
                      Text(
                        "Percent change 1h: ${currentCoin.percentChange1h
                            .toStringAsFixed(4)}",
                        style: textStyle,
                      ),
                      Text(
                        "Percent change 24h: ${currentCoin.percentChange24h
                            .toStringAsFixed(4)}",
                        style: textStyle,
                      ),
                      Text(
                        "Percent change 7d: ${currentCoin.percentChange7d
                            .toStringAsFixed(4)}",
                        style: textStyle,
                      ),
                      Text(
                        "Last updated: $hour:$minute, $day/$month/$year",
                        style: textStyle,
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
        onRefresh: () async {
          print('onRefresh');
          actionGetCoins();
        },
      ),
    );
  }
}
