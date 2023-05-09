class Item {
  final int? id;
  final String nama;
  final int jumlah;

  Item({this.id, required this.nama, required this.jumlah});

  factory Item.fromMap(Map<String, dynamic> json) =>
      Item(id: json['id'], nama: json['name'], jumlah: json['jumlah']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': nama, 'jumlah': jumlah};
  }
}
