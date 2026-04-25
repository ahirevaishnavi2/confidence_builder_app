import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/flashcard_model.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Flashcard> _flashcards = [];
  List<Flashcard> _filteredFlashcards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Vocabulary',
    'Public Speaking',
    'Confidence Tips',
  ];

  // Pre-loaded flashcards
  final List<Map<String, String>> _predefinedCards = [
    {
      'question': 'What does "eloquent" mean?',
      'answer': 'Fluent or persuasive in speaking or writing',
      'category': 'Vocabulary',
    },
    {
      'question': 'What is the "Rule of Three" in public speaking?',
      'answer':
          'People tend to remember information presented in groups of three',
      'category': 'Public Speaking',
    },
    {
      'question': 'How to manage nervousness before a speech?',
      'answer':
          'Deep breathing, practice beforehand, positive visualization, and start with a strong opening',
      'category': 'Confidence Tips',
    },
    {
      'question': 'What does "articulate" mean?',
      'answer':
          'Having or showing the ability to speak fluently and coherently',
      'category': 'Vocabulary',
    },
    {
      'question': 'What is the ideal speech pace?',
      'answer': '140-160 words per minute for clarity and engagement',
      'category': 'Public Speaking',
    },
    {
      'question': 'What is imposter syndrome?',
      'answer':
          'Doubting your abilities and feeling like a fraud despite success',
      'category': 'Confidence Tips',
    },
    {
      'question': 'What does "persuasive" mean?',
      'answer': 'Good at convincing others to believe or do something',
      'category': 'Vocabulary',
    },
    {
      'question': 'What are the 3 parts of a speech?',
      'answer': 'Introduction, Body, and Conclusion',
      'category': 'Public Speaking',
    },
    {
      'question': 'How to build confidence?',
      'answer':
          'Practice daily, celebrate small wins, positive self-talk, and step out of comfort zone',
      'category': 'Confidence Tips',
    },
    {
      'question': 'What does "charismatic" mean?',
      'answer':
          'Exercising a compelling charm that inspires devotion in others',
      'category': 'Vocabulary',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    final List<Flashcard> cards = [];
    for (int i = 0; i < _predefinedCards.length; i++) {
      final card = _predefinedCards[i];
      cards.add(
        Flashcard(
          id: 'card_$i',
          question: card['question']!,
          answer: card['answer']!,
          category: card['category']!,
        ),
      );
    }
    setState(() {
      _flashcards = cards;
      _filterFlashcards();
    });
  }

  void _filterFlashcards() {
    if (_selectedCategory == 'All') {
      _filteredFlashcards = _flashcards;
    } else {
      _filteredFlashcards = _flashcards
          .where((card) => card.category == _selectedCategory)
          .toList();
    }
    setState(() {
      _currentIndex = 0;
      _isFlipped = false;
    });
  }

  void _nextCard() {
    if (_currentIndex < _filteredFlashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
    } else {
      _showCompletionMessage();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
      });
    }
  }

  void _markMastered() {
    setState(() {
      _filteredFlashcards[_currentIndex].isMastered = true;
      _filteredFlashcards[_currentIndex].lastReviewed = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Great! Card marked as mastered!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    // Move to next card after marking
    if (_currentIndex < _filteredFlashcards.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _nextCard();
      });
    }
  }

  void _showCompletionMessage() {
    int masteredCount = _filteredFlashcards
        .where((card) => card.isMastered)
        .length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: Text(
          'You\'ve completed all flashcards in this category!\n\n'
          'Mastered: $masteredCount/${_filteredFlashcards.length} cards\n\n'
          'Keep practicing to build your confidence!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _isFlipped = false;
              });
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  int _getMasteredCount() {
    return _filteredFlashcards.where((card) => card.isMastered).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Category filter
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String value) {
              setState(() {
                _selectedCategory = value;
                _filterFlashcards();
              });
            },
            itemBuilder: (context) => _categories.map((category) {
              return PopupMenuItem(value: category, child: Text(category));
            }).toList(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade50, Colors.purple.shade50],
          ),
        ),
        child: _filteredFlashcards.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.style, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No flashcards in this category',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Progress indicator
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category: $_selectedCategory',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Progress: ${_currentIndex + 1}/${_filteredFlashcards.length}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value:
                              (_currentIndex + 1) / _filteredFlashcards.length,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mastered: ${_getMasteredCount()}/${_filteredFlashcards.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Flashcard
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFlipped = !_isFlipped;
                          });
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isFlipped
                              ? _buildAnswerCard()
                              : _buildQuestionCard(),
                        ),
                      ),
                    ),
                  ),

                  // Navigation buttons
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _previousCard,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black87,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _markMastered,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Mastered'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _nextCard,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      key: const ValueKey('question'),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.help_outline, size: 50, color: Colors.white70),
            const SizedBox(height: 20),
            Text(
              _filteredFlashcards[_currentIndex].question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Tap to reveal answer',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard() {
    final card = _filteredFlashcards[_currentIndex];
    return Card(
      key: const ValueKey('answer'),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.green.shade500],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb, size: 50, color: Colors.white70),
            const SizedBox(height: 20),
            Text(
              card.answer,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                card.category,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            if (card.isMastered) ...[
              const SizedBox(height: 10),
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
