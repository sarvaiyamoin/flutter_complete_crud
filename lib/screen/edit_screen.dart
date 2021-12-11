import 'package:flutter/material.dart';
import 'package:flutter_complete_crud/controller/employee_data.dart';
import 'package:flutter_complete_crud/model/employee.dart';
import 'package:get/get.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  EmployeeData employeeData = Get.put(EmployeeData());
  final _form = GlobalKey<FormState>();
  var _editEmployee = Employee(id: "null", name: "", email: "", salary: 0);
  var _intValue = {'name': '', 'email': '', 'salary': ''};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final employeeId = Get.arguments;
    if (employeeId != null) {
      _editEmployee = employeeData.findEmployeeById(employeeId);
      _intValue = {
        'name': _editEmployee.name,
        'email': _editEmployee.email,
        'salary': _editEmployee.salary.toString()
      };
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editEmployee.id != "null") {
      await employeeData.updateEmployee(_editEmployee.id, _editEmployee);
      setState(() {
        _isLoading = false;
      });
      Get.back();
    } else {
      try {
        await employeeData.addEmployee(_editEmployee);
      } catch (error) {
        await Get.defaultDialog(
            title: 'An error occured!',
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: const Text("Ok"))
            ]);
      } finally {
        setState(() {
          _isLoading = false;
        });
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editEmployee.id != "null"
            ? const Text("Edit Employee")
            : const Text("Add Employee"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: _intValue['name'],
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Moin",
                          prefixIcon: Icon(Icons.contact_page),
                          label: Text("Name"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editEmployee = Employee(
                              id: _editEmployee.id,
                              name: value!,
                              email: _editEmployee.email,
                              salary: _editEmployee.salary);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _intValue['email'],
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "abc@gmail.com",
                          prefixIcon: Icon(Icons.email),
                          label: Text("Email"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editEmployee = Employee(
                              id: _editEmployee.id,
                              name: _editEmployee.name,
                              email: value!,
                              salary: _editEmployee.salary);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _intValue['salary'],
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "10000",
                          prefixIcon: Icon(Icons.money),
                          label: Text("Salary"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter salary";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editEmployee = Employee(
                              id: _editEmployee.id,
                              name: _editEmployee.name,
                              email: _editEmployee.email,
                              salary: int.parse(value!));
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          child: _editEmployee.id != "null"
                              ? const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                )
                              : const Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: () {
                            _saveForm();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )),
    );
  }
}
