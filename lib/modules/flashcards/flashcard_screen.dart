import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/flashcard_model.dart';
import '../../services/flashcard_service.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final FlashcardService _flashcardService = FlashcardService();
  int _currentIndex = 0;
  bool _isFlipped = false;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Interview',
    'Business',
    'Daily Use',
    'Public Speaking',
    'Professional Communication',
  ];

  void _nextCard(int totalCards) {
    if (_currentIndex < totalCards - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
    } else {
      _showCompletionMessage(totalCards);
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

  void _showCompletionMessage(int totalCards) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: const Text(
          'You\'ve gone through all your flashcards in this category!\n\n'
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

  void _showAddFlashcardDialog() {
    final frontController = TextEditingController();
    final backController = TextEditingController();
    String category = _categories[1]; // Default to first real category

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Flashcard'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: frontController,
                  decoration: const InputDecoration(
                    labelText: 'Front Page Text',
                    hintText: 'Enter question or term',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: backController,
                  decoration: const InputDecoration(
                    labelText: 'Back Page Text',
                    hintText: 'Enter answer or definition',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: category,
                  items: _categories
                      .where((c) => c != 'All')
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (frontController.text.isNotEmpty &&
                    backController.text.isNotEmpty) {
                  _flashcardService.addFlashcard(Flashcard(
                    id: '',
                    front: frontController.text,
                    back: backController.text,
                    category: category,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Flashcard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard?'),
        content: const Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _flashcardService.deleteFlashcard(card.id);
              Navigator.pop(context);
              setState(() {
                if (_currentIndex > 0) _currentIndex--;
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String value) {
              setState(() {
                _selectedCategory = value;
                _currentIndex = 0;
              });
            },
            itemBuilder: (context) => _categories.map((category) {
              return PopupMenuItem(value: category, child: Text(category));
            }).toList(),
          ),
        ],
      ),
      body: StreamBuilder<List<Flashcard>>(
        stream: _flashcardService.getFlashcards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allCards = snapshot.data ?? [];
          final filteredCards = _selectedCategory == 'All'
              ? allCards
              : allCards.where((c) => c.category == _selectedCategory).toList();

          if (filteredCards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.style, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    allCards.isEmpty
                        ? 'No flashcards yet. Add some!'
                        : 'No flashcards in this category',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showAddFlashcardDialog,
                    child: const Text('Add Your First Flashcard'),
                  ),
                ],
              ),
            );
          }

          // Ensure index is valid
          if (_currentIndex >= filteredCards.length) {
            _currentIndex = 0;
          }

          final currentCard = filteredCards[_currentIndex];

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple.shade50, Colors.purple.shade50],
              ),
            ),
            child: Column(
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
                            'Progress: ${_currentIndex + 1}/${filteredCards.length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_currentIndex + 1) / filteredCards.length,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Flashcard
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFlipped = !_isFlipped;
                            });
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isFlipped
                                ? _buildAnswerCard(currentCard)
                                : _buildQuestionCard(currentCard),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.white70),
                            onPressed: () => _confirmDelete(currentCard),
                          ),
                        ),
                      ],
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
                        onPressed: _currentIndex > 0 ? _previousCard : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _flashcardService.markAsMastered(
                              currentCard.id, !currentCard.isMastered);
                        },
                        icon: Icon(
                          currentCard.isMastered
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                        ),
                        label: Text(
                            currentCard.isMastered ? 'Mastered' : 'Master?'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentCard.isMastered
                              ? Colors.green
                              : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _nextCard(filteredCards.length),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFlashcardDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuestionCard(Flashcard card) {
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
              card.front,
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
                'Tap to reveal back',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard(Flashcard card) {
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
              card.back,
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
