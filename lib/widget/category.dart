import 'package:flutter/material.dart';
import 'package:quiz/admin/admin_dashboard.dart';
import 'package:quiz/screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../constraints.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    fetchCategories();
    Get.appUpdate();
  }

  Future<void> fetchCategories() async {
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
          categories =
              data.keys.toList(); // Fetch root-level keys as categories
        });

        print('Categories fetched successfully: $categories');
      } else {
        print('Error fetching categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          title: const Text(
            "Quiz App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          elevation: 0,
          backgroundColor: bg,
          actions: [
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
              onPressed: () {
                Get.to(const Admin());
              },
            ),
          ],
        ),
        body: LiquidPullToRefresh(
            onRefresh: refresh,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Please Select Category",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(child: ButtonList(items: categories)),
            ])));
  }
}

class ButtonList extends StatelessWidget {
  const ButtonList({super.key, required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CategoryButton(
          func: () {
            Get.to(
              HomeScreen(category: items[index]),
            );
          },
          category: items[index],
        );
      },
    );
  }
}

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.func, required this.category});
  final VoidCallback func;
  final String category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: func,
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Color(0xFF121212)),
            shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )),
            backgroundColor: WidgetStatePropertyAll(Color(0xFF1FDF64)),
          ),
          child: Text(category),
        ),
      ),
    );
  }
}
