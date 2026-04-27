class Flashcard {
  final String id;
  final String front;
  final String back;
  final String category;
  bool isMastered;
  DateTime lastReviewed;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.category,
    this.isMastered = false,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'category': category,
      'isMastered': isMastered,
      'lastReviewed': lastReviewed.toIso8601String(),
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] ?? '',
      front: json['front'] ?? json['question'] ?? '', // Fallback for old data
      back: json['back'] ?? json['answer'] ?? '',     // Fallback for old data
      category: json['category'] ?? 'General',
      isMastered: json['isMastered'] ?? false,
      lastReviewed: DateTime.parse(json['lastReviewed'] ?? DateTime.now().toIso8601String()),
    );
  }
}
