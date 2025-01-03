class Users {
  
}

class Question {
  String? question;
  String? answer;

  Question();

  Map<String, dynamic> toJson() => {'question': question};
}