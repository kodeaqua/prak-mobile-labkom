import 'dart:convert';
import 'package:restapi/models/item.dart';
import 'package:http/http.dart' as http;

class ItemService {
  static const _baseUrl = 'http://10.0.2.2:8000/api/items';

  static Future<void> createItem(Item item) async {
    final response = await http.post(Uri.parse(_baseUrl),
        body: json.encode({'nama': item.nama, 'jumlah': item.jumlah}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to create item');
    }
  }

  static Future<List<Item>> readItems() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((itemJson) => Item.fromJson(itemJson)).toList();
    } else {
      throw Exception('Failed to read items');
    }
  }

  static Future<void> updateItem(int id, String nama, int jumlah) async {
    final response = await http.put(Uri.parse('$_baseUrl/$id'),
        body: json.encode({'nama': nama, 'jumlah': jumlah}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
  }

  static Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }
}
