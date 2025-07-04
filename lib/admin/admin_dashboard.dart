import "package:flutter/material.dart";
import 'package:quiz/widget/category.dart';
import "../model/db_connect.dart";
import '../admin/Admin_screen.dart';
import '../constraints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../admin/question_controller.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});
  @override
  State<Admin> createState() => _Admin();
}

class _Admin extends State<Admin> {
  final QuestionController questioncontroller = Get.put(QuestionController());
  List<String> subjects = [];

  @override
  void initState() {
    //questioncontroller.loadQuestionCategoryfromsharedpreferences();
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    const url = "https://quizapp-19185-default-rtdb.firebaseio.com/.json";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = response.body;

        if (body == 'null' || body.isEmpty) {
          return;
        }

        final data = jsonDecode(body) as Map<String, dynamic>?;

        if (data == null) {
          return;
        }

        setState(() {
          subjects = data.keys.toList(); // Fetch root-level keys as categories
        });

        print('Categories fetched successfully: $subjects');
      } else {
        print('Error fetching categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void showdialogbox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(15.0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            backgroundColor: Colors.black,
            title: const Text(
              'Add Quiz',
              style: TextStyle(color: neutral),
            ),
            content: Column(
              children: [
                TextFormField(
                  controller: questioncontroller.categoryTitleController,
                  style: const TextStyle(color: neutral),
                  decoration: const InputDecoration(
                      hintText: "Enter the Category name",
                      hintStyle: TextStyle(color: neutral)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(correct),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: neutral),
                ),
              ),
              ElevatedButton(
                  onPressed: createcategory,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(correct),
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(color: neutral),
                  )),
            ],
          );
        });
  }

  void createcategory() async {
    String S = questioncontroller.categoryTitleController.text;
    final url =
        Uri.parse('https://quizapp-19185-default-rtdb.firebaseio.com/$S.json');
    http.post(
      url,
      body: json.encode({
        'id': '',
        'title': '',
      }),
    );
    Navigator.of(context).pop();
    await Future.delayed(const Duration(seconds: 2));
    questioncontroller.categoryTitleController.clear();
    //Get.snackbar('Category', 'Category created successfully');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category created successfully')));
    }
    subjects.clear();
    fetchSubjects();
    Get.appUpdate();
    await Future.delayed(const Duration(seconds: 2));
  }

  void deleteCategory(String Category) async {
    DBconnect().deleteCategory(Category);
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
          title: const Text(
            'Admin DashBoard',
            style: TextStyle(color: neutral),
            textAlign: TextAlign.left,
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Execute some functionality before navigating back
                print('Executing functionality before navigating back');
                Get.to(const CategoryScreen()); // Navigate back
              }),
          backgroundColor: correct,
          shadowColor: Colors.transparent),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(AdminScreen(QuizCategory: subjects[index]));
                  },
                  leading: const Icon(Icons.question_answer),
                  title: Text(subjects[index]),
                  trailing: IconButton(
                      onPressed: () {
                        deleteCategory(subjects[index]);
                        subjects.clear();
                        fetchSubjects();
                        controller.update();
                        Get.appUpdate();
                      },
                      icon: const Icon(Icons.delete)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showdialogbox,
        child: const Icon(Icons.add),
      ),
    );
  }
}
