import 'package:flutter/material.dart';
import 'package:flutter_complete_crud/controller/employee_data.dart';
import 'package:flutter_complete_crud/screen/edit_screen.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter CRUD"),
        actions: [
          IconButton(
              onPressed: () => Get.to(const EditScreen()),
              icon: const Icon(Icons.add))
        ],
      ),
      body: GetBuilder<EmployeeData>(
        init: EmployeeData(),
        initState: (_) {},
        builder: (employeeData) {
          return employeeData.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: employeeData.refreshEmployees,
                  child: ListView.builder(
                      itemCount: employeeData.employee.length,
                      itemBuilder: (_, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: FittedBox(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(employeeData.employee[index].name),
                              )),
                            ),
                            title: Text(
                              employeeData.employee[index].email,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              employeeData.employee[index].salary.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.to(const EditScreen(),
                                          arguments:
                                              employeeData.employee[index].id);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.yellow.shade700,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      try {
                                        await employeeData.deleteEmployee(
                                            employeeData.employee[index].id);
                                      } catch (error) {
                                        Get.rawSnackbar(
                                            titleText: const Text(
                                              "Faild To Delete",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                              ),
                                            ),
                                            message: error.toString());
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade700,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const EditScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
