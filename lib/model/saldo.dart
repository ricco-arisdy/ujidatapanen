class Saldo {
  final int id;
  final int idLoading;
  final int userId;
  final double totalPanen;
  final double pendapatan;
  final String createdAt;

  Saldo({
    required this.id,
    required this.idLoading,
    required this.userId,
    required this.totalPanen,
    required this.pendapatan,
    required this.createdAt,
  });

  factory Saldo.fromJson(Map<String, dynamic> json) {
  return Saldo(
    id: json['id'],
    idLoading: json['id_loading'],
    userId: json['id_user'],
    totalPanen: (json['total_panen'] ?? 0).toDouble(), 
    pendapatan: (json['pendapatan'] ?? 0).toDouble(), 
    createdAt: json['created_at'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_loading': idLoading,
      'id_user': userId,
      'total_panen': totalPanen,
      'pendapatan': pendapatan,
      'created_at': createdAt,
    };
  }
}