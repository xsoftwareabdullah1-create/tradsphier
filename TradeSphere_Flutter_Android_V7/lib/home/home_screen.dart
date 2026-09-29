import 'package:flutter/material.dart';
import '../../models/asset.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('TradeSphere', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Paper trading account', style: TextStyle(color: Colors.grey.shade400)),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Portfolio value'),
                  SizedBox(height: 8),
                  Text('₹1,25,430', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('+₹4,820 (+3.99%)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Watchlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...demoAssets.take(4).map((a) => ListTile(
            title: Text('${a.symbol} · ${a.name}'),
            subtitle: Text(a.price.toStringAsFixed(2)),
            trailing: Text('${a.change24h >= 0 ? '+' : ''}${a.change24h.toStringAsFixed(2)}%'),
          )),
        ],
      ),
    );
  }
}
