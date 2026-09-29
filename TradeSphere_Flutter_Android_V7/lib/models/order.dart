enum OrderSide { buy, sell }
enum OrderStatus { open, filled, cancelled, rejected }

class TradeOrder {
  final String id;
  final String symbol;
  final OrderSide side;
  final double quantity;
  final double price;
  final OrderStatus status;
  final DateTime createdAt;

  const TradeOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  TradeOrder copyWith({OrderStatus? status}) => TradeOrder(
    id: id, symbol: symbol, side: side, quantity: quantity,
    price: price, status: status ?? this.status, createdAt: createdAt,
  );
}
