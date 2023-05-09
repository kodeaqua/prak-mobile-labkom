class Item {
  int id;
  String nama;
  int jumlah;

  Item({required this.id, required this.nama, required this.jumlah});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as int,
      nama: json['nama'] as String,
      jumlah: json['jumlah'] as int);

  Map<String, dynamic> toJson() => {'id': id, 'nama': nama, 'jumlah': jumlah};
}
