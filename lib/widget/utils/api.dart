import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'dart:math';

class Api {
  static const String baseUrl = 'https://patrolgst.com/api';
  String? _bearerToken;
  final DateFormat _timeFormat = DateFormat("hh:mm a");

  void setBearerToken(String token) {
    _bearerToken = token;
  }

  Future<String> fetchBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_key');
    if (authToken == null) {
      throw Exception('Auth token not found in SharedPreferences.');
    }
    _bearerToken = authToken;
    return authToken;
  }

  Map<String, String> _getAuthHeaders() {
    if (_bearerToken == null) {
      throw Exception('Bearer token is not set.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
  }

  Future<dynamic> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      setBearerToken(responseBody['token']);
      return responseBody;
    } else {
      throw Exception('Failed to login.');
    }
  }

  Future<dynamic> getSites() async {
    final response = await http.get(
      Uri.parse('$baseUrl/sites'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch sites.');
    }
  }

  Future<dynamic> addSite(Map<String, String> siteData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sites'),
      headers: _getAuthHeaders(),
      body: jsonEncode(siteData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add site.');
    }
  }

  Future<dynamic> updateSite(int siteId, Map<String, String> siteData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/sites/$siteId'),
      headers: _getAuthHeaders(),
      body: jsonEncode(siteData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update site.');
    }
  }

  // Inside your Api class
  Future<dynamic> getTimesheets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/timesheets'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch timesheets.');
    }
  }

  String _randomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  // Add this method to your Api class in api.dart
  Future<dynamic> createTimesheet(Map<String, dynamic> timesheetData,
      {File? checkInPhoto}) async {
    Api api = Api();
    String token = await api.fetchBearerToken();
    _bearerToken = token;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/timesheets'),
    );

    request.headers.addAll(_getAuthHeaders());

    for (var entry in timesheetData.entries) {
      if (entry.key == 'checkInPhoto' || entry.key == 'checkOutPhoto') {
        Uint8List? imageData;
        if (base64.decode(entry.value) is File) {
          imageData = await entry.value.readAsBytes();
        } else if (entry.value is Uint8List) {
          imageData = entry.value;
        } else {
          imageData = base64.decode(entry.value);
        }
        if (imageData != null) {
          String uniqueTimestamp =
              DateTime.now().millisecondsSinceEpoch.toString();
          String randomSuffix = _randomString(5);
          String fileExtension =
              '.png'; // Change this based on the actual image format
          String uniqueFilename =
              '$uniqueTimestamp-$randomSuffix$fileExtension';

          // Limit the filename to 10 characters (excluding the file extension)
          uniqueFilename =
              uniqueFilename.substring(0, min(10, uniqueFilename.length)) +
                  fileExtension;

          request.files.add(
            http.MultipartFile.fromBytes(
              entry.key,
              imageData,
              filename: uniqueFilename,
              contentType: MediaType('image',
                  'png'), // Change this based on the actual image format
            ),
          );
        }
      } else if (entry.key == 'clockInTime' || entry.key == 'clockOutTime') {
        DateTime now = DateTime.now();
        String formattedTime = DateFormat('HH:mm:ss').format(now);
        request.fields[entry.key] = formattedTime;
      } else {
        request.fields[entry.key] = entry.value.toString();
      }
    }

    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonResponse;
    } else {
      throw Exception('Failed to create timesheet.');
    }
  }

  // Add this method to your Api class in api.dart
  Future<dynamic> updateTimesheet(
      int timesheetId, Map<String, String> timesheetData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/timesheets/$timesheetId'),
      headers: _getAuthHeaders(),
      body: jsonEncode(timesheetData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update timesheet.');
    }
  }
}
