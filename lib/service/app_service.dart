import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pockit/model/add_transaction_entities.dart';
import 'package:pockit/model/pocket_entities.dart';
import 'package:pockit/model/tag_entities.dart';
import 'package:pockit/model/transaction_entities.dart';

class TransactionService {
  Future<TransactionResponse> getTransactions(int userId, String date, int page, int size) async {
    final url = Uri.parse('https://83mbl26v-7777.asse.devtunnels.ms/api/v1/transaction?userId=$userId&date=$date&page=$page&size=$size');

    try {
      final response = await http.get(url);
       print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return TransactionResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal mengambil data transaksi. Kode status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
    Future<void> addTransaction(AddTransactionEntities transaction) async {
    final url = Uri.parse('https://83mbl26v-7777.asse.devtunnels.ms/api/v1/transaction/create');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(transaction.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Gagal menambahkan transaksi. Kode status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
  Future<List<TagEntities>> getTags() async {
    final url = Uri.parse('https://83mbl26v-7777.asse.devtunnels.ms/api/v1/tag');
    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final tagResponse = TagResponse.fromJson(jsonResponse);
        return tagResponse.data;  // Correct: returning the List<TagEntities> from tagResponse
      } else {
        throw Exception('Gagal mengambil data tag. Kode status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
Future<List<PocketEntity>> getPockets() async {
  final url = Uri.parse('https://83mbl26v-7777.asse.devtunnels.ms/api/v1/pocket?userId=1&page=0&size=10');
  try {
    final response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final pocketResponse = PocketResponse.fromJson(jsonResponse);
      return pocketResponse.data.pockets;  // Updated: returning the pockets list from data
    } else {
      throw Exception('Gagal mengambil data pocket. Kode status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Terjadi kesalahan: $e');
  }
}
}