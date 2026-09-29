import 'package:flutter/material.dart';
import '../../models/asset.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});
  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final list = demoAssets.where((a) =>
      a.symbol.toLowerCase().contains(q.toLowerCase()) ||
      a.name.toLowerCase().contains(q.toLowerCase())
    ).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              onChanged: (v) => setState(() => q = v),
              decoration: const InputDecoration(
                hintText: 'Search markets',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
                  return Card(
                    child: ListTile(
                      title: Text('${a.symbol} · ${a.name}'),
                      subtitle: Text(a.price.toStringAsFixed(2)),
                      trailing: Text('${a.change24h >= 0 ? '+' : ''}${a.change24h.toStringAsFixed(2)}%'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
