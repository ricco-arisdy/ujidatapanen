class Lahan {
  final int id;
  final String namaLahan;
  final String lokasi;
  final int luas;
  final int userId;

  Lahan({
    required this.id,
    required this.namaLahan,
    required this.lokasi,
    required this.luas,
    required this.userId,
  });

  factory Lahan.fromJson(Map<String, dynamic> json) {
    return Lahan(
      id: json['id'],
      namaLahan: json['nama_lahan'],
      lokasi: json['lokasi'],
      luas: json['luas'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_lahan': namaLahan,
      'lokasi': lokasi,
      'luas': luas,
      'user_id': userId,
    };
  }
}