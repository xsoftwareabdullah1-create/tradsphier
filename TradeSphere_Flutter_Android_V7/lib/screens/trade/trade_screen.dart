import 'package:flutter/material.dart';
import '../../models/asset.dart';
import '../../services/order_service.dart';
import '../../services/orders_api.dart';
import '../../services/api_client.dart';
import '../auth/login_screen.dart';
import '../orders/order_history_screen.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});
  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  String side = 'BUY';
  Asset asset = demoAssets.first;
  final qty = TextEditingController(text: '1');
  final ordersApi = OrdersApi();
  bool loggedIn = false;
  bool paymentLinked = false;

  @override
  void dispose() {
    qty.dispose();
    super.dispose();
  }

  void submit() {
    final quantity = double.tryParse(qty.text) ?? 0;
    final result = OrderService.validate(
      side: side,
      quantity: quantity,
      owned: asset.owned,
      loggedIn: loggedIn,
      paymentLinked: paymentLinked,
    );

    if (result.accepted) {
      try {
        await ordersApi.create(symbol: asset.symbol, side: side, quantity: quantity, price: asset.price);
      } catch (e) {
        final message = e is ApiException ? e.message : e.toString();
        if (mounted) {
          showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Order Rejected'), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
        }
        return;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(result.accepted ? 'Order Placed' : 'Order Rejected'),
        content: Text(result.message),
        actions: [
          if (!loggedIn)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final ok = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
                if (ok == true && mounted) setState(() => loggedIn = true);
              },
              child: const Text('Login'),
            ),
          if (loggedIn && !paymentLinked)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => paymentLinked = true);
              },
              child: const Text('Link Demo Payment'),
            ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quantity = double.tryParse(qty.text) ?? 0;
    final total = quantity * asset.price;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text('Trade', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    IconButton(
      tooltip: 'Order history',
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen())),
      icon: const Icon(Icons.receipt_long),
    ),
  ],
),
          const SizedBox(height: 18),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'BUY', label: Text('BUY')),
              ButtonSegment(value: 'SELL', label: Text('SELL')),
            ],
            selected: {side},
            onSelectionChanged: (s) => setState(() => side = s.first),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<Asset>(
            value: asset,
            decoration: const InputDecoration(labelText: 'Asset'),
            items: demoAssets.map((a) => DropdownMenuItem(value: a, child: Text(a.symbol))).toList(),
            onChanged: (v) => setState(() => asset = v!),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: qty,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Quantity',
              helperText: side == 'SELL' ? 'Available: ${asset.owned}' : null,
            ),
          ),
          const SizedBox(height: 14),
          Text('Estimated total: ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          FilledButton(onPressed: submit, child: Text('$side ${asset.symbol}')),
          const SizedBox(height: 14),
          Text(
            'Demo mode: no real money or live exchange order is sent.',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
