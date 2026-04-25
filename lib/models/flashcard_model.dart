class Flashcard {
  final String id;
  final String question;
  final String answer;
  final String category;
  bool isMastered;
  DateTime lastReviewed;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isMastered = false,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'isMastered': isMastered,
      'lastReviewed': lastReviewed.toIso8601String(),
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      category: json['category'],
      isMastered: json['isMastered'],
      lastReviewed: DateTime.parse(json['lastReviewed']),
    );
  }
}
