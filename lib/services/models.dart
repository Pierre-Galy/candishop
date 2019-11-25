import 'package:firebase_database/firebase_database.dart';

class Option {
  String value;
  String detail;
  bool correct;
  Option({ this.correct, this.value, this.detail });
  Option.fromMap(Map data) {
    value = data['value'];
    detail = data['detail'] ?? '';
    correct = data['correct'];
  }
}
class Question {
  String text;
  List<Option> options;
  Question({ this.options, this.text });
  Question.fromMap(Map data) {
    text = data['text'] ?? '';
    options = (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
  }
}
///// Database Collections
class Quiz { 
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;
  Quiz({ this.title, this.questions, this.video, this.description, this.id, this.topic });
  factory Quiz.fromMap(Map data) {
    return Quiz(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      topic: data['topic'] ?? '',
      description: data['description'] ?? '',
      video: data['video'] ?? '',
      questions: (data['questions'] as List ?? []).map((v) => Question.fromMap(v)).toList()
    );
  }
}
// WISH
class Wish { 
  String id;
  String title;
  String description;
  String photo;
  String author;
  Wish({ this.title, this.photo, this.description, this.id, this.author });
  factory Wish.fromMap(Map data) {
    return Wish(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      photo: data['photo'] ?? ''
    );
  }
}
class Topic {
  final String id;
  final String title;
  final  String description;
  final String img;
  final List<Quiz> quizzes;
  Topic({ this.id, this.title, this.description, this.img, this.quizzes });
  factory Topic.fromMap(Map data) {
    return Topic(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      img: data['img'] ?? 'angular.png',
      quizzes:  (data['quizzes'] as List ?? []).map((v) => Quiz.fromMap(v)).toList(), //data['quizzes'],
    );
  }
}
class User {
  String uid;
  int total;
  dynamic topics;
  String lastname;
  String firstname;
  String email;
  User({ this.uid, this.topics, this.total, this.lastname, this.email, this.firstname });
  factory User.fromMap(Map data) {
    return User(
      uid: data['uid'],
      lastname: data['lastname'],
      firstname: data['firstname'],
      email: data['email'],
      total: data['total'] ?? 0,
      topics: data['topics'] ?? {},
    );
  }
}
/*class User {
  String _username;
  String _password;
  User(this._username, this._password);
  User.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];
  }
  String get username => _username;
  String get password => _password;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    return map;
  }
}*/
class Todo {
  String key;
  String subject;
  bool completed;
  String userId;
  Todo(this.subject, this.userId, this.completed);
  Todo.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    subject = snapshot.value["subject"],
    completed = snapshot.value["completed"];
  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
    };
  }
}