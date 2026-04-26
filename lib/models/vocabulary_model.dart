class VocabularyWord {
  final String id;
  final String word;
  final String meaning;
  final String synonym;
  final String exampleSentence;
  final String category;
  bool isSaved;

  VocabularyWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.synonym,
    required this.exampleSentence,
    required this.category,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'meaning': meaning,
        'synonym': synonym,
        'exampleSentence': exampleSentence,
        'category': category,
        'isSaved': isSaved,
      };

  factory VocabularyWord.fromJson(Map<String, dynamic> json) => VocabularyWord(
        id: json['id'],
        word: json['word'],
        meaning: json['meaning'],
        synonym: json['synonym'],
        exampleSentence: json['exampleSentence'],
        category: json['category'],
        isSaved: json['isSaved'] ?? false,
      );
}

class ReadingSnippet {
  final String title;
  final String content;
  final List<String> highlightedWords;
  final String source;

  const ReadingSnippet({
    required this.title,
    required this.content,
    required this.highlightedWords,
    required this.source,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
