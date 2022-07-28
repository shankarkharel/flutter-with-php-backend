// ignore_for_file: avoid_print, prefer_collection_literals, constant_identifier_names, import_of_legacy_library_into_null_safe, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
//import http package to make http requests
import 'package:http/http.dart' as http;
import 'employee.dart';

class Services {
  static Uri url = Uri.parse('http://localhost/TestDB_server/script.php');
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(url, body: map);
      log('Create Table Response: ${response.toString()}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      log('Create Table ERROR: $e');
      return "error";
    }
  }

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(url, body: map);
      log('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        //return a list litral
        List<Employee> growableList = List<Employee>.filled(
            500, Employee(id: '', firstName: '', lastName: ''));
        log('growableList: $growableList');
        return growableList;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addEmployee(String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(url, body: map);
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateEmployee(
      String empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(url, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(url, body: map);
      print('deleteEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
