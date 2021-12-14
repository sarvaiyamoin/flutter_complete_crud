import 'dart:convert';
import 'package:flutter_complete_crud/model/http_exception.dart';

import '../model/employee.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EmployeeData extends GetxController {
  // List<Employee> employee = [
  //   Employee(
  //       id: "1",
  //       name: "Moin",
  //       email: "sarvaiyamoin786@gmail.com",
  //       salary: 12000),
  // ];

  var employee = RxList<Employee>([]);
  var isLoading = false;

  @override
  void onInit() {
    isLoading = true;
    fetchAndSetEmployee().then((_) {
      isLoading = false;
    });
    super.onInit();
  }

  Employee findEmployeeById(String id) {
    return employee.firstWhere((employee) => employee.id == id);
  }

  Future<void> fetchAndSetEmployee() async {
    final url = Uri.parse(
        "https://flutter-crud-f71cd-default-rtdb.firebaseio.com/employee.json");
    try {
      final response = await http.get(url);
      final extratedData = jsonDecode(response.body) as Map<String, dynamic>;
      var loadedEmployee = RxList<Employee>([]);
      // List<Employee> loadedEmployee = [];
// List<Employee> employeeFromJson(String str) => List<Employee>.from(
//           json.decode(str).map((x) => Employee.fromJson(x)));

      extratedData.forEach((employeeId, employeeData) {
        loadedEmployee.add(Employee(
            id: employeeId,
            name: employeeData['name'],
            email: employeeData['email'],
            salary: employeeData['salary']));
      });
      employee = loadedEmployee;
      update();
    } catch (error) {}
  }

  Future<void> addEmployee(Employee newEmployee) async {
    final url = Uri.parse(
        "https://flutter-crud-f71cd-default-rtdb.firebaseio.com/employee.json");
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': newEmployee.name,
            'email': newEmployee.email,
            'salary': newEmployee.salary
          }));
      employee.add(Employee(
          id: json.decode(response.body)['name'],
          name: newEmployee.name,
          email: newEmployee.email,
          salary: newEmployee.salary));
      update();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteEmployee(String id) async {
    final url = Uri.parse(
        "https://flutter-crud-f71cd-default-rtdb.firebaseio.com/employee/$id.json");
    final existingEmployeeIndex =
        employee.indexWhere((employee) => employee.id == id);
    var existingEmploye = employee[existingEmployeeIndex];
    employee.removeWhere((employee) => employee.id == id);
    update();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      employee.insert(existingEmployeeIndex, existingEmploye);
      update();
      throw HttpException("Faild to delete this employee data");
    }
  }

  Future<void> updateEmployee(String id, Employee newEmployee) async {
    final employeeIndex = employee.indexWhere((employee) => employee.id == id);
    if (employeeIndex >= 0) {
      final url = Uri.parse(
          "https://flutter-crud-f71cd-default-rtdb.firebaseio.com/employee/$id.json");
      await http.patch(url,
          body: json.encode({
            'name': newEmployee.name,
            'email': newEmployee.email,
            'salary': newEmployee.salary
          }));
      employee[employeeIndex] = newEmployee;
      update();
    }
  }

  Future<void> refreshEmployees() async {
    await fetchAndSetEmployee();
  }
}
