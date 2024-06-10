class User {
  final int id;
  final String username;
  final String alamat;
  final int no_telp;
  final String email;
  final String password;
  final String? tanggalBergabung;

  User({
    required this.id,
    required this.username,
    required this.alamat,
    required this.no_telp,
    required this.email,
    required this.password,
    this.tanggalBergabung,
  });
}
