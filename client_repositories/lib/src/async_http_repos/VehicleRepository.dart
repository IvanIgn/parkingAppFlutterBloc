// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'dart:convert';
// import 'package:shared/shared.dart';

// class VehicleRepository {
//   static final VehicleRepository _instance = VehicleRepository._internal();
//   static VehicleRepository get instance => _instance;
//   VehicleRepository._internal();

//   Future<Vehicle> getVehicleById(int id) async {
//     final uri = Uri.parse("http://localhost:8080/vehicles/$id");

//     Response response = await http.get(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//     );

//     final json = jsonDecode(response.body);

//     return Vehicle.fromJson(json);
//   }

//   Future<Vehicle> createVehicle(Vehicle vehicle) async {
//     final uri = Uri.parse("http://localhost:8080/vehicles");

//     Response response = await http.post(uri,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(vehicle.toJson()));

//     final json = jsonDecode(response.body);

//     return Vehicle.fromJson(json);
//   }

//   Future<List<Vehicle>> getAllVehicles() async {
//     final uri = Uri.parse("http://localhost:8080/vehicles");
//     Response response = await http.get(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//     );

//     final json = jsonDecode(response.body);

//     return (json as List).map((vehicle) => Vehicle.fromJson(vehicle)).toList();
//   }

//   Future<Vehicle> deleteVehicle(int id) async {
//     final uri = Uri.parse("http://localhost:8080/vehicles/$id");

//     Response response = await http.delete(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//     );

//     final json = jsonDecode(response.body);

//     return Vehicle.fromJson(json);
//   }

//   Future<Vehicle> updateVehicle(int id, Vehicle vehicle) async {
//     final uri = Uri.parse("http://localhost:8080/vehicles/$id");

//     Response response = await http.put(uri,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(vehicle.toJson()));

//     final json = jsonDecode(response.body);

//     return Vehicle.fromJson(json);
//   }
// }

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared/shared.dart';

class VehicleRepository {
  static final VehicleRepository _instance = VehicleRepository._internal();
  static VehicleRepository get instance => _instance;
  VehicleRepository._internal();

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles");

    // Create a copy of vehicle without the ID for creation
    final vehicleData = vehicle.toJson();
    vehicleData.remove('id'); // Remove the 'id' field if it exists

    Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicleData),
    );

    _checkResponse(response);

    try {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } catch (e) {
      throw Exception('Failed to parse response: ${response.body}, error: $e');
    }
  }

  Future<Vehicle> getVehicleById(int id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/${id}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    _checkResponse(response);

    try {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } catch (e) {
      throw Exception('Failed to parse response: ${response.body}, error: $e');
    }
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final uri = Uri.parse("http://localhost:8080/vehicles");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    _checkResponse(response);

    try {
      final json = jsonDecode(response.body);
      return (json as List)
          .map((vehicle) => Vehicle.fromJson(vehicle))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse response: ${response.body}, error: $e');
    }
  }

  Future<Vehicle> deleteVehicle(int id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    _checkResponse(response);

    try {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } catch (e) {
      throw Exception('Failed to parse response: ${response.body}, error: $e');
    }
  }

  Future<Vehicle> updateVehicle(int id, Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/${id}");

    Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    _checkResponse(response);

    try {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } catch (e) {
      throw Exception('Failed to parse response: ${response.body}, error: $e');
    }
  }

  /// Helper method to check the response status code
  void _checkResponse(Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Request failed with status: ${response.statusCode}, body: ${response.body}');
    }

    if (response.body.isEmpty) {
      throw Exception('Server returned an empty response.');
    }
  }
}

// import 'dart:convert';
// import 'dart:io'; // Import for platform detection
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:shared/shared.dart';

// class VehicleRepository {
//   static final VehicleRepository _instance = VehicleRepository._internal();
//   static VehicleRepository get instance => _instance;
//   VehicleRepository._internal();

//   // Helper method to determine the base URL based on the platform
//   String _getBaseUrl() {
//     if (Platform.isAndroid || Platform.isIOS) {
//       // Use the emulator's special IP address to access localhost from Android emulator
//       return "http://10.0.2.2:8080";
//     } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//       // Use localhost for Windows and other desktop platforms
//       return "http://localhost:8080";
//     } else {
//       // Fallback if the platform is not recognized
//       throw UnsupportedError("Unsupported platform");
//     }
//   }

//   Uri _getUri(String path) {
//     // Ensure the path doesn't start with a forward slash if needed
//     return Uri.parse("$_getBaseUrl()/$path");
//   }

//   Future<Vehicle> createVehicle(Vehicle vehicle) async {
//     final uri = _getUri("vehicles");

//     // Create a copy of vehicle without the ID for creation
//     final vehicleData = vehicle.toJson();
//     vehicleData.remove('id'); // Remove the 'id' field if it exists

//     Response response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(vehicleData),
//     );

//     _checkResponse(response);

//     try {
//       final json = jsonDecode(response.body);
//       return Vehicle.fromJson(json);
//     } catch (e) {
//       throw Exception('Failed to parse response: ${response.body}, error: $e');
//     }
//   }

//   Future<Vehicle> getVehicleById(int id) async {
//     final uri = _getUri("vehicles/$id");

//     Response response = await http.get(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//     );

//     _checkResponse(response);

//     try {
//       final json = jsonDecode(response.body);
//       return Vehicle.fromJson(json);
//     } catch (e) {
//       throw Exception('Failed to parse response: ${response.body}, error: $e');
//     }
//   }

//   Future<List<Vehicle>> getAllVehicles() async {
//     final uri = _getUri("vehicles");

//     Response response = await http.get(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//     );

//     _checkResponse(response);

//     try {
//       final json = jsonDecode(response.body);
//       return (json as List)
//           .map((vehicle) => Vehicle.fromJson(vehicle))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to parse response: ${response.body}, error: $e');
//     }
//   }

//   Future<Vehicle> deleteVehicle(int id) async {
//     final uri = _getUri("vehicles/$id");

//     Response response = await http.delete(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//     );

//     _checkResponse(response);

//     try {
//       final json = jsonDecode(response.body);
//       return Vehicle.fromJson(json);
//     } catch (e) {
//       throw Exception('Failed to parse response: ${response.body}, error: $e');
//     }
//   }

//   Future<Vehicle> updateVehicle(int id, Vehicle vehicle) async {
//     final uri = _getUri("vehicles/$id");

//     Response response = await http.put(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(vehicle.toJson()),
//     );

//     _checkResponse(response);

//     try {
//       final json = jsonDecode(response.body);
//       return Vehicle.fromJson(json);
//     } catch (e) {
//       throw Exception('Failed to parse response: ${response.body}, error: $e');
//     }
//   }

//   /// Helper method to check the response status code
//   void _checkResponse(Response response) {
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       throw Exception(
//           'Request failed with status: ${response.statusCode}, body: ${response.body}');
//     }

//     if (response.body.isEmpty) {
//       throw Exception('Server returned an empty response.');
//     }
//   }
// }
