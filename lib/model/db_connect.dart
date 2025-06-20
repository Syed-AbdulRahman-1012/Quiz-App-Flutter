import 'package:http/http.dart' as http;
import 'question_model.dart';
import 'dart:convert';

class DBconnect {
  //final _link="https://quizappnew-a7cb4-default-rtdb.firebaseio.com/categories/";
  final _link = "https://quizapp-19185-default-rtdb.firebaseio.com/";

  //final _link="https://simple-quiz-27a36-default-rtdb.asia-southeast1.firebasedatabase.app/";

  Future<void> addQuestion(Question question, String tablename) async {
    final url = Uri.parse('$_link$tablename.json');
    http.post(
      url,
      body: json.encode({
        'title': question.title,
        'options': question.options,
      }),
    );
  }

  Future<List<Question>> fetchQuestions(String category) async {
    final url = Uri.parse('$_link$category.json');

    final response = await http.get(url);

    final data = json.decode(response.body);

    List<Question> newQuestions = [];

    data.forEach((key, value) {
      if (value != null &&
          value is Map<String, dynamic> &&
          value.containsKey('options') &&
          value.containsKey('title')) {
        final options = Map<String, bool>.from(value['options']);

        var newQuestion = Question(
          id: key,
          title: value['title'],
          options: options,
        );
        newQuestions.add(newQuestion);
      }
    });

    return newQuestions;
  }

  Future<void> deleteCategory(String Category) async {
    final url = Uri.parse('$_link$Category.json');
    http.delete(url);
  }
}
