import 'package:flutter/material.dart';
import '../../models/asset.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Portfolio', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ...demoAssets.where((a) => a.owned > 0).map((a) => Card(
            child: ListTile(
              title: Text(a.symbol),
              subtitle: Text('${a.owned} units'),
              trailing: Text((a.owned * a.price).toStringAsFixed(2)),
            ),
          )),
        ],
      ),
    );
  }
}
