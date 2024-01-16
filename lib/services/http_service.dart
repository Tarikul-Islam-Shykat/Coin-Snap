

import 'package:coin_cap/model/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService{
  final Dio dio = Dio();
  AppConfig? _appConfig;
  String? _baseUrl;

  HTTPService(){
    _appConfig = GetIt.instance.get<AppConfig>(); // getting the object of singleton instance using get it
    _baseUrl = _appConfig!.COIN_BASE_API_URL;
  }

  Future<Response?> getResponse(String _path ) async { // getting the response from api
    try{
      String _url = "$_baseUrl$_path";
      Response _response = await dio.get(_url);
      return _response;

    }catch(e){
      print("HTTPS service error");
      print(e.toString());
    }

  }



}