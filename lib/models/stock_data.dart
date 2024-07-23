class StockData {
  final DateTime da;
  final double op;
  final double hi;
  final double lo;
  final double cl;

  StockData({
    required this.da,
    required this.op,
    required this.hi,
    required this.lo,
    required this.cl,
  });
}

class StockSnapshot {
  final int symbol;
  final String codename;
  final String industry;
  final String ranking;

  StockSnapshot({
    required this.symbol,
    required this.codename,
    required this.industry,
    required this.ranking,
  });
}