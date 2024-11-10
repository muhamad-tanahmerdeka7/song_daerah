import 'package:http/http.dart' as http;

import '../models/lagu_response_model.dart';

class LaguRemoteDatasource {
  Future<LaguResponseModel> getLaguDaerah() async {
    final response =
        await http.get(Uri.parse('http://172.16.100.53:8000/api/lagudaerah'));
    if (response.statusCode == 200) {
      return LaguResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<LaguResponseModel> getLaguDaerahPages(int page) async {
    final response = await http
        .get(Uri.parse('http://172.16.100.53:8000/api/lagudaerah?page=$page'));
    if (response.statusCode == 200) {
      return LaguResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
