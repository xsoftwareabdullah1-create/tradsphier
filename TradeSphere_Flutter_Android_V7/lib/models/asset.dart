class Asset {
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final double owned;

  const Asset({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    this.owned = 0,
  });
}

const demoAssets = <Asset>[
  Asset(symbol: 'BTC', name: 'Bitcoin', price: 67234, change24h: 2.4, owned: 4),
  Asset(symbol: 'ETH', name: 'Ethereum', price: 3450, change24h: 1.8, owned: 1.2456),
  Asset(symbol: 'SOL', name: 'Solana', price: 152, change24h: 4.1, owned: 10),
  Asset(symbol: 'AAPL', name: 'Apple', price: 229, change24h: -0.7, owned: 5),
  Asset(symbol: 'TSLA', name: 'Tesla', price: 240, change24h: 3.2, owned: 2),
];
