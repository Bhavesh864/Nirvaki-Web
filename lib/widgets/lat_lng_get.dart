import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<LatLng?> getLatLng(String query) async {
  const apiKey = 'AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA';
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$apiKey';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final lat = json['results'][0]['geometry']['location']['lat'];
    final lng = json['results'][0]['geometry']['location']['lng'];
    return LatLng(lat, lng);
  } else {
    return null;
  }
}
