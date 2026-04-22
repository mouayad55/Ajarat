import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // ---------------------------------------------------------------------------
  // HELPER: GET HEADERS
  // ---------------------------------------------------------------------------
  // Retrieves the token from storage and creates the headers.
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    var headers = {
      'Accept': 'application/json',
      // We do not set 'Content-Type' here generally because Multipart requests
      // need to set their own boundary automatically.
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ---------------------------------------------------------------------------
  // GET REQUEST
  // ---------------------------------------------------------------------------
  Future<dynamic> get(String url) async {
    final headers = await _getHeaders();
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // POST REQUEST (JSON)
  // ---------------------------------------------------------------------------
  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    headers['Content-Type'] = 'application/json'; // Explicitly set for JSON

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // MULTIPART REQUEST (For Photos)
  // ---------------------------------------------------------------------------
  // Used for Registration and Adding Apartments
  Future<dynamic> postMultipart(
    String url,
    Map<String, String> fields,
    Map<String, File> files,
  ) async {
    final headers = await _getHeaders();
    // Do NOT set Content-Type to application/json here.
    
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add Text Fields (e.g., name, phone)
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add Files (e.g., id_photo, personal_photo)
    for (var entry in files.entries) {
      if (entry.value.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
        );
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // PUT REQUEST
  // ---------------------------------------------------------------------------
  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    headers['Content-Type'] = 'application/json';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE REQUEST
  // ---------------------------------------------------------------------------
  Future<dynamic> delete(String url) async {
    final headers = await _getHeaders();
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // RESPONSE PROCESSOR
  // ---------------------------------------------------------------------------
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else {
      // Error
      String message = 'Something went wrong';
      try {
        final body = jsonDecode(response.body);
        if (body['message'] != null) {
          message = body['message'];
        } else if (body['error'] != null) {
          message = body['error'];
        }
      } catch (_) {
        message = 'Error ${response.statusCode}: ${response.reasonPhrase}';
      }
      throw Exception(message);
    }
  }
}