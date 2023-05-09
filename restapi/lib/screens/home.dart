import 'package:flutter/material.dart';
import 'package:restapi/models/item.dart';
import 'package:restapi/services/item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _items = [];
  Future<void> _fetchItems() async {
    try {
      final items = await ItemService.readItems();
      setState(() {
        _items = items;
      });
    } catch (e) {
      // print('Error fetching items: $e');
    }
  }

  Future<void> _addItem(Item item) async {
    try {
      await ItemService.createItem(item);
      await _fetchItems();
    } catch (e) {
      // print('Error creating item: $e');
    }
  }

  Future<void> _updateItem(Item item) async {
    try {
      await ItemService.updateItem(item.id, item.nama, item.jumlah);
      await _fetchItems();
    } catch (e) {
      // print('Error creating item: $e');
    }
  }

  Future<void> _deleteItem(Item item) async {
    try {
      await ItemService.deleteItem(item.id);
      setState(() {
        _items.remove(item);
      });
    } catch (e) {
      // print('Error deleting item: $e');
    }
  }

  Future<void> _showDialog(BuildContext context, Item? item,
      {bool delete = false}) {
    final namaController =
        TextEditingController(text: item != null ? item.nama : "");

    final jumlahController = TextEditingController(
        text: item != null ? item.jumlah.toString() : "0");

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return delete
            ? AlertDialog(
                title: const Text("Hapus data"),
                content: const Text(
                    'Data ini akan terhapus baik dari aplikasi maupun web service API. Yakin ingin menghapus?'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Batal'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Hapus'),
                    onPressed: () {
                      _deleteItem(item!);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(const Duration(milliseconds: 500),
                          () => Navigator.of(context).pop());
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: item != null
                    ? const Text('Ubah data')
                    : const Text('Tambah data'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                        ),
                      ),
                      TextField(
                        controller: jumlahController,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Batal'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Simpan'),
                    onPressed: () {
                      final nama = namaController.text;
                      final jumlah = int.tryParse(jumlahController.text);

                      if (jumlah == null || jumlah.isNaN) {
                        return;
                      }

                      item != null
                          ? _updateItem(
                              Item(id: item.id, nama: nama, jumlah: jumlah))
                          : _addItem(Item(id: 1, nama: nama, jumlah: jumlah));

                      namaController.clear();
                      jumlahController.clear();

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(const Duration(milliseconds: 500),
                          () => Navigator.of(context).pop());
                    },
                  ),
                ],
              );
      },
    );
  }

  final snackBar = const SnackBar(
    content: Text('Yay! Berhasil~'),
  );

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REST API"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(child: Text('Pengembang')),
                    content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ListView(
                          children: [
                            ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.person),
                                ],
                              ),
                              title: const Text("Adam Najmi Zidan"),
                              subtitle: const Text("Developer"),
                            ),
                            ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.person),
                                ],
                              ),
                              title: const Text("Prayoga Anom R."),
                              subtitle: const Text("Developer"),
                            )
                          ],
                        )),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Tutup'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }),
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum ada data",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star),
                    ],
                  ),
                  title: Text(item.nama),
                  subtitle: Text('Jumlah: ${item.jumlah}'),
                  onLongPress: () => _showDialog(context, item, delete: true),
                  onTap: () => _showDialog(context, item),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(context, null),
        tooltip: 'Tambah Item',
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add),
            Text("Tambah"),
          ],
        ),
      ),
    );
  }
}
