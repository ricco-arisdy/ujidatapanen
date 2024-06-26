class Loading {
  final int id;
  final String namaLoading;
  final String pemilik;
  final String alamat;
  final String lokasi;
  final int userId;

  Loading({
    required this.id,
    required this.namaLoading,
    required this.pemilik,
    required this.alamat,
    required this.lokasi,
    required this.userId,
  });

  factory Loading.fromJson(Map<String, dynamic> json) {
    return Loading(
      id: json['id'],
      namaLoading: json['nama_loading'],
      pemilik: json['pemilik'],
      alamat: json['alamat'],
      lokasi: json['lokasi'],
      userId: json[
          'user_id'], // Sesuaikan dengan key yang digunakan di JSON response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_loading': namaLoading,
      'pemilik': pemilik,
      'alamat': alamat,
      'lokasi': lokasi,
      'user_id': userId,
    };
  }
}
