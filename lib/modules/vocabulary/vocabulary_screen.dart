import 'package:flutter/material.dart';
import '../../models/vocabulary_model.dart';
import '../../data/vocabulary_data.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<VocabularyWord> _allWords = [];
  List<VocabularyWord> _savedWords = [];
  List<VocabularyWord> _filteredWords = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Interview',
    'Business',
    'Daily Use',
    'Public Speaking',
    'Professional Communication',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _allWords = List.from(VocabularyData.allWords);
    _applyFilters();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredWords = _allWords.where((word) {
        final matchesCategory =
            _selectedCategory == 'All' || word.category == _selectedCategory;
        final matchesSearch = _searchQuery.isEmpty ||
            word.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            word.meaning.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
      _savedWords = _allWords.where((w) => w.isSaved).toList();
    });
  }

  void _toggleSave(VocabularyWord word) {
    setState(() {
      word.isSaved = !word.isSaved;
      _savedWords = _allWords.where((w) => w.isSaved).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          word.isSaved ? '❤️ "${word.word}" saved!' : '💔 Removed from saved',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor:
            word.isSaved ? Colors.deepPurple.shade700 : Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text(
          'Vocabulary Practice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.orange,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: '🏠 Home'),
            Tab(text: '🃏 Flashcards'),
            Tab(text: '📖 Reading'),
            Tab(text: '🧩 Quiz'),
            Tab(text: '❤️ Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildFlashcardsTab(),
          _buildReadingTab(),
          _buildQuizTab(),
          _buildSavedTab(),
        ],
      ),
    );
  }
void _showWordMeaning(BuildContext context, String word) {
  final meanings = {
    "eloquent": "Fluent and persuasive in speaking",
    "profound": "Very deep or intense",
    "sagacious": "Wise and insightful",
    "rhetoric": "Effective persuasive speaking or writing",
    "articulate": "Able to express clearly",

    "innate": "Natural from birth",
    "resilient": "Able to recover quickly",
    "self-assured": "Confident in oneself",
    "proactive": "Taking initiative early",
    "candid": "Honest and direct",

    "empathy": "Understanding others' feelings",
    "perspicacity": "Sharp insight and understanding",
    "nuanced": "Subtle with fine distinctions",
    "coveted": "Highly desired",
    "competencies": "Important skills or abilities",
  };

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            meanings[word.toLowerCase()] ?? "Meaning not available",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
  // ─── HOME TAB ────────────────────────────────────────────────────────────────
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word of the Day
          _buildWordOfTheDayCard(),
          const SizedBox(height: 20),
          // Quote of the Day
          _buildQuoteCard(),
          const SizedBox(height: 20),
          // Search
          _buildSearchBar(),
          const SizedBox(height: 16),
          // Category Filter
          _buildCategoryFilter(),
          const SizedBox(height: 16),
          // Word List
          Text(
            '${_filteredWords.length} Words',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ..._filteredWords.map((word) => _buildWordListCard(word)),
        ],
      ),
    );
  }

  Widget _buildWordOfTheDayCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Word of the Day',
                style: TextStyle(
                  color: Colors.orange.shade300,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            VocabularyData.wordOfTheDay,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            VocabularyData.wordOfTheDayMeaning,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Syn: ${VocabularyData.wordOfTheDaySynonym}',
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '"${VocabularyData.wordOfTheDayExample}"',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💬',
              style: TextStyle(fontSize: 28, color: Colors.orange.shade400)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quote of the Day',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  VocabularyData.quoteOfTheDay,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (val) {
        setState(() => _searchQuery = val);
        _applyFilters();
      },
      decoration: InputDecoration(
        hintText: 'Search vocabulary...',
        prefixIcon: Icon(Icons.search, color: Colors.deepPurple.shade400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat);
              _applyFilters();
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.deepPurple.shade700 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.deepPurple.shade700
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWordListCard(VocabularyWord word) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _categoryColor(word.category)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word.category,
                  style: TextStyle(
                    fontSize: 10,
                    color: _categoryColor(word.category),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  word.word,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () => _toggleSave(word),
                child: Icon(
                  word.isSaved ? Icons.favorite : Icons.favorite_border,
                  color: word.isSaved
                      ? Colors.deepPurple.shade700
                      : Colors.grey.shade400,
                  size: 22,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('📌 Meaning', word.meaning),
                  const SizedBox(height: 8),
                  _infoRow('🔄 Synonym', word.synonym),
                  const SizedBox(height: 8),
                  _infoRow('📝 Example', '"${word.exampleSentence}"',
                      italic: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool italic = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Interview':
        return Colors.blue.shade600;
      case 'Business':
        return Colors.green.shade700;
      case 'Daily Use':
        return Colors.orange.shade700;
      case 'Public Speaking':
        return Colors.deepPurple.shade600;
      case 'Professional Communication':
        return Colors.teal.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  // ─── FLASHCARDS TAB ──────────────────────────────────────────────────────────
  Widget _buildFlashcardsTab() {
    return _FlashcardsView(
      words: _allWords,
      onToggleSave: _toggleSave,
    );
  }

  // ─── READING TAB ─────────────────────────────────────────────────────────────
  Widget _buildReadingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Reading',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade800,
            ),
          ),
          Text(
            'Expand your vocabulary through context',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ...VocabularyData.readingSnippets
              .map((s) => _buildReadingSnippetCard(s)),
        ],
      ),
    );
  }

  Widget _buildReadingSnippetCard(ReadingSnippet snippet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.deepPurple.shade400
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                const Text('📖', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snippet.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        snippet.source,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHighlightedText(
                    snippet.content, snippet.highlightedWords),
                const SizedBox(height: 16),
                Text(
                  'Advanced Words in This Passage:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: snippet.highlightedWords
    .map((w) => GestureDetector(
          onTap: () => _showWordMeaning(context, w),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.deepPurple.shade200),
            ),
            child: Text(
              w,
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ))
    .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(String text, List<String> highlights) {
    final lowerHighlights =
        highlights.map((h) => h.toLowerCase()).toList();
    final words = text.split(' ');
    final spans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final rawWord = words[i];
      final cleanWord =
          rawWord.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
      final isHighlighted = lowerHighlights.contains(cleanWord);

      spans.add(TextSpan(
        text: i < words.length - 1 ? '$rawWord ' : rawWord,
        style: TextStyle(
          color: isHighlighted
              ? Colors.deepPurple.shade700
              : Colors.grey.shade800,
          fontWeight:
              isHighlighted ? FontWeight.bold : FontWeight.normal,
          backgroundColor: isHighlighted
              ? Colors.deepPurple.withValues(alpha: 0.08)
              : null,
          fontSize: 14,
          height: 1.7,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  // ─── QUIZ TAB ────────────────────────────────────────────────────────────────
  Widget _buildQuizTab() {
    return _QuizView(questions: VocabularyData.quizQuestions);
  }

  // ─── SAVED TAB ───────────────────────────────────────────────────────────────
  Widget _buildSavedTab() {
    return _savedWords.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border,
                    size: 70, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No saved words yet',
                  style: TextStyle(
                      fontSize: 18, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap ❤️ on any word to save it here',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.shade400),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_savedWords.length} Saved Words',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                ..._savedWords.map((word) => _buildWordListCard(word)),
              ],
            ),
          );
  }
}

// ─── FLASHCARDS VIEW ─────────────────────────────────────────────────────────

class _FlashcardsView extends StatefulWidget {
  final List<VocabularyWord> words;
  final Function(VocabularyWord) onToggleSave;

  const _FlashcardsView(
      {required this.words, required this.onToggleSave});

  @override
  State<_FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<_FlashcardsView> {
  int _currentIndex = 0;
  bool _isFlipped = false;
  String _selectedCategory = 'All';
  late List<VocabularyWord> _filtered;
  double _dragStart = 0;

  final List<String> _categories = [
    'All',
    'Interview',
    'Business',
    'Daily Use',
    'Public Speaking',
    'Professional Communication',
  ];

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      _filtered = _selectedCategory == 'All'
          ? List.from(widget.words)
          : widget.words
              .where((w) => w.category == _selectedCategory)
              .toList();
      _currentIndex = 0;
      _isFlipped = false;
    });
  }

  void _next() {
    if (_filtered.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _filtered.length;
      _isFlipped = false;
    });
  }

  void _prev() {
    if (_filtered.isEmpty) return;
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _filtered.length) % _filtered.length;
      _isFlipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_filtered.isEmpty) {
      return const Center(child: Text('No words in this category'));
    }

    final word = _filtered[_currentIndex];

    return Column(
      children: [
        // Category selector
        Container(
          color: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = cat);
                        _applyFilter();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurple.shade700
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} / ${_filtered.length}',
                style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Tap card to flip',
                style:
                    TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              GestureDetector(
                onTap: () => widget.onToggleSave(word),
                child: Icon(
                  word.isSaved ? Icons.favorite : Icons.favorite_border,
                  color: word.isSaved
                      ? Colors.deepPurple.shade700
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _filtered.length,
            backgroundColor: Colors.grey.shade200,
            color: Colors.deepPurple.shade700,
            borderRadius: BorderRadius.circular(8),
            minHeight: 6,
          ),
        ),

        // Flashcard
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isFlipped = !_isFlipped),
            onHorizontalDragStart: (d) => _dragStart = d.localPosition.dx,
            onHorizontalDragEnd: (d) {
              if (d.primaryVelocity! < -300) _next();
              if (d.primaryVelocity! > 300) _prev();
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: child,
                ),
                child: _isFlipped
                    ? _buildBackCard(word)
                    : _buildFrontCard(word),
              ),
            ),
          ),
        ),

        // Navigation
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navButton(
                  '← Prev', Colors.grey.shade200, Colors.black87, _prev),
              _navButton('Flip 🔄',
                  Colors.deepPurple.shade100, Colors.deepPurple.shade700,
                  () => setState(() => _isFlipped = !_isFlipped)),
              _navButton('Next →', Colors.deepPurple.shade700,
                  Colors.white, _next),
            ],
          ),
        ),
      ],
    );
  }

  Widget _navButton(
      String label, Color bg, Color fg, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildFrontCard(VocabularyWord word) {
    return Card(
      key: const ValueKey('front'),
      elevation: 10,
      shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade500
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                word.category,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              word.word,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.touch_app, color: Colors.white38, size: 16),
                SizedBox(width: 6),
                Text(
                  'Tap to see meaning',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard(VocabularyWord word) {
    return Card(
      key: const ValueKey('back'),
      elevation: 10,
      shadowColor: Colors.teal.withValues(alpha: 0.3),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade700, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  word.word,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _backSection('📌 Meaning', word.meaning),
              const SizedBox(height: 14),
              _backSection('🔄 Synonym', word.synonym),
              const SizedBox(height: 14),
              _backSection(
                  '📝 Example', '"${word.exampleSentence}"'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, height: 1.5),
        ),
      ],
    );
  }
}

// ─── QUIZ VIEW ───────────────────────────────────────────────────────────────

class _QuizView extends StatefulWidget {
  final List<QuizQuestion> questions;
  const _QuizView({required this.questions});

  @override
  State<_QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<_QuizView> {
  int _currentQ = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;
  bool _quizFinished = false;

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == widget.questions[_currentQ].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQ < widget.questions.length - 1) {
      setState(() {
        _currentQ++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      setState(() => _quizFinished = true);
    }
  }

  void _restart() {
    setState(() {
      _currentQ = 0;
      _selectedOption = null;
      _answered = false;
      _score = 0;
      _quizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizFinished) return _buildResult();
    final q = widget.questions[_currentQ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQ + 1}/${widget.questions.length}',
                style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Score: $_score',
                  style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (_currentQ + 1) / widget.questions.length,
            backgroundColor: Colors.grey.shade200,
            color: Colors.deepPurple.shade700,
            borderRadius: BorderRadius.circular(8),
            minHeight: 6,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.deepPurple.shade500
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              q.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(q.options.length, (index) {
            Color bg = Colors.white;
            Color border = Colors.grey.shade200;
            Color textColor = Colors.grey.shade800;
            IconData? icon;

            if (_answered) {
              if (index == q.correctIndex) {
                bg = Colors.green.shade50;
                border = Colors.green;
                textColor = Colors.green.shade800;
                icon = Icons.check_circle;
              } else if (index == _selectedOption) {
                bg = Colors.red.shade50;
                border = Colors.red;
                textColor = Colors.red.shade800;
                icon = Icons.cancel;
              }
            } else if (_selectedOption == index) {
              bg = Colors.deepPurple.shade50;
              border = Colors.deepPurple.shade400;
            }

            return GestureDetector(
              onTap: () => _selectOption(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.07),
                        blurRadius: 6,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: border == Colors.grey.shade200
                            ? Colors.grey.shade100
                            : border.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(q.options[index],
                          style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              fontWeight: _answered &&
                                      index == q.correctIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ),
                    if (icon != null)
                      Icon(icon, color: textColor, size: 20),
                  ],
                ),
              ),
            );
          }),
          if (_answered)
            Center(
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _currentQ < widget.questions.length - 1
                      ? 'Next Question →'
                      : 'See Results 🎉',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final percent = (_score / widget.questions.length * 100).round();
    final emoji = percent >= 80
        ? '🏆'
        : percent >= 60
            ? '👍'
            : '📚';
    final message = percent >= 80
        ? 'Outstanding! You\'re a vocabulary master!'
        : percent >= 60
            ? 'Good job! Keep practicing daily.'
            : 'Keep learning — consistency is key!';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_score / ${widget.questions.length} Correct',
              style: TextStyle(
                  fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
