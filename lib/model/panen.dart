class Panen {
  final int id;
  final String noPanen;
  final DateTime tanggalPanen;
  final double jumlah;
  final double harga;
  final String foto;
  final String deskripsi;
  final int idLahan;
  final int idLoading;

  Panen({
    required this.id,
    required this.noPanen,
    required this.tanggalPanen,
    required this.jumlah,
    required this.harga,
    required this.foto,
    required this.deskripsi,
    required this.idLahan,
    required this.idLoading,
  });

  factory Panen.fromJson(Map<String, dynamic> json) {
    return Panen(
      id: json['id'],
      noPanen: json['no_panen'],
      tanggalPanen: DateTime.parse(json['tanggal_panen']),
      jumlah: double.parse(json['jumlah'].toString()),
      harga: double.parse(json['harga'].toString()),
      foto: json['foto'],
      deskripsi: json['deskripsi'],
      idLahan: json['id_lahan'],
      idLoading: json['id_loading'],
    );
  }
}