class Task {
  String content;
  DateTime timeStamp;
  bool done;

  Task({
    required this.content,
    required this.timeStamp,
    required this.done,
  });
  // map function
  Map toMap() {
    return {
      'content': content,
      'timeStamp': timeStamp,
      'done': done,
    };
  }
  // factory method
  factory Task.fromMap(Map task) {
    return Task(
      content: task['content'],
      timeStamp: task['timeStamp'],
      done: task['done'],
    );
  }
}
