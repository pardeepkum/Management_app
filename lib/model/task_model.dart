class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dateCreated;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dateCreated,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }


  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      dateCreated: DateTime.parse(map['dateCreated']),
    );
  }


  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dateCreated,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }
}
