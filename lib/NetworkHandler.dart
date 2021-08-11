import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:simple_blog_app/Res/endpoint.dart';
import 'package:simple_blog_app/Res/storage_key.dart' as key;

class NetworkHandler {
  //my baseUrl
  String baseUrl = endpoint;

  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  // helper function
  Uri formater(String url) {
    return Uri.parse('${baseUrl + url}');
  }

  String formaterUrl(String url) {
    return baseUrl + url;
  }

  NetworkImage getImage(String imageName) {
    String url = formaterUrl("/uploads/$imageName.jpg");
    return NetworkImage(url);
  }

  // network function
  Future get(String url) async {
    String token = await storage.read(key: key.token);
    Uri uri = formater(url);

    // /user/register
    var response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return jsonDecode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String token = await storage.read(key: key.token);
    Uri uri = formater(url);
    log.d(body);
    var response = await http.post(
      uri,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    String token = await storage.read(key: key.token);
    Uri uri = formater(url);
    log.d(body);
    var response = await http.post(
      uri,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formate(url);
    String token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({"Content-type": "multipart/form-data", "Authorization": "Bearer $token"});
    var response = request.send();
    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    Uri uri = formater(url);
    log.d(body);
    var response = await http.patch(
      uri,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(body),
    );
    return response;
  }

  String formate(String url) {
    return baseUrl + url;
  }
}
