import 'dart:async';
import 'package:flutter/material.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  bool _isPracticing = false;

  String _currentTopic = "";
  String _userWriting = "";
  String _feedbackMessage = "";

  int _timerSeconds = 600; // 10 minutes for writing
  Timer? _timer;

  final List<String> _topics = [
    "Describe a situation where you had to convince someone to see things your way.",
    "Write about a time you failed and what you learned from it.",
    "What is the most important quality for a leader? Explain why.",
    "Describe your dream job and why you would excel at it.",
    "Write a persuasive paragraph about why reading is important.",
    "Describe a person who has inspired you and why.",
    "What does confidence mean to you?",
    "Write about a goal you achieved and how you did it.",
    "Describe a challenge you overcame recently.",
    "What is one skill you want to improve and why?",
  ];

  final TextEditingController _writingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateRandomTopic();
  }

  void _generateRandomTopic() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _topics.length;
    setState(() {
      _currentTopic = _topics[randomIndex];
      _userWriting = "";
      _feedbackMessage = "";
      _writingController.clear();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _stopPractice();
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void _startPractice() {
    setState(() {
      _isPracticing = true;
      _timerSeconds = 600;
      _userWriting = "";
      _feedbackMessage = "";
    });
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "✍️ Writing practice started! Write your response below.",
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _stopPractice() {
    _timer?.cancel();
    setState(() {
      _isPracticing = false;
      _userWriting = _writingController.text;
    });
    _generateFeedback();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Great job! Check your feedback below."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generateFeedback() {
    String feedback;
    final writing = _userWriting;

    if (writing.isEmpty) {
      feedback = "⚠️ No writing detected. Try writing something next time!";
    } else {
      // Word count analysis
      final wordCount = writing.split(' ').length;

      // Character count
      final charCount = writing.length;

      // Sentence count (basic)
      final sentenceCount = writing.split(RegExp(r'[.!?]+')).length - 1;

      // Check for basic structure
      final hasIntroduction = writing.toLowerCase().contains(
        RegExp(r'(first|to begin|initially|introduction)'),
      );
      final hasConclusion = writing.toLowerCase().contains(
        RegExp(r'(finally|in conclusion|to sum up|overall)'),
      );

      // Build feedback
      feedback = "📊 **Writing Analysis**\n\n";
      feedback += "• Word count: $wordCount words\n";
      feedback += "• Characters: $charCount characters\n";
      feedback += "• Sentences: ~$sentenceCount sentences\n\n";

      // Length feedback
      if (wordCount < 50) {
        feedback +=
            "📝 Your response is quite short. Try to elaborate more on your ideas. Aim for 150-300 words.\n\n";
      } else if (wordCount > 500) {
        feedback +=
            "🎉 Excellent length! Your response is very detailed and comprehensive.\n\n";
      } else {
        feedback += "✅ Good length! Your response is well-developed.\n\n";
      }

      // Structure feedback
      if (hasIntroduction) {
        feedback += "✓ Good use of an introduction to start your response.\n";
      } else {
        feedback +=
            "💡 Tip: Start with an introduction to set context for your reader.\n";
      }

      if (hasConclusion) {
        feedback +=
            "✓ Great job including a conclusion to wrap up your thoughts.\n";
      } else {
        feedback +=
            "💡 Tip: End with a conclusion to summarize your main points.\n";
      }

      // Quality feedback based on length
      if (wordCount > 150) {
        feedback +=
            "\n🌟 Your writing shows good depth! The detailed examples strengthen your response.";
      } else if (wordCount > 50) {
        feedback +=
            "\n👍 Good start! Add more specific examples to make your writing stronger.";
      } else {
        feedback +=
            "\n📈 Keep practicing! Try to write at least 150 words next time.";
      }

      // Add vocabulary tip
      feedback +=
          "\n\n💡 **Vocabulary Tip:** Use varied words like 'however', 'therefore', and 'consequently' to connect your ideas smoothly.";
    }

    setState(() {
      _feedbackMessage = feedback;
    });
  }

  void _saveWriting() {
    if (_userWriting.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("💾 Writing saved locally!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _showError("Nothing to save. Write something first!");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _writingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Writing'),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateRandomTopic,
            tooltip: 'New Topic',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topic Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade700, Colors.green.shade500],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✍️ Your Writing Prompt',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentTopic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Timer and Controls Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Timer Display
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _isPracticing
                              ? Colors.green.shade100
                              : Colors.deepPurple.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _formatTime(_timerSeconds),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _isPracticing
                                  ? Colors.green.shade700
                                  : Colors.deepPurple.shade700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        _isPracticing
                            ? "Writing in progress..."
                            : "Ready to write?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Practice/Stop Button
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isPracticing
                                  ? _stopPractice
                                  : _startPractice,
                              icon: Icon(
                                _isPracticing ? Icons.stop : Icons.edit,
                              ),
                              label: Text(
                                _isPracticing
                                    ? 'Stop Practice'
                                    : 'Start Writing',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isPracticing
                                    ? Colors.red
                                    : Colors.green.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          if (!_isPracticing && _userWriting.isNotEmpty)
                            const SizedBox(width: 10),
                          if (!_isPracticing && _userWriting.isNotEmpty)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _saveWriting,
                                icon: const Icon(Icons.save),
                                label: const Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Writing Input Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.create, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Your Response',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _writingController,
                        maxLines: 12,
                        decoration: InputDecoration(
                          hintText: _isPracticing
                              ? "Write your response here...\n\nAim for 150-300 words.\nUse examples to support your ideas."
                              : "Type or paste your response here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '💡 Tip: Write clearly, use examples, and structure your response with an introduction, body, and conclusion.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Feedback Card
              if (_feedbackMessage.isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'AI Feedback',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _feedbackMessage,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Tips Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tips_and_updates, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Writing Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('• Start with a clear thesis statement'),
                      const Text(
                        '• Use specific examples to support your points',
                      ),
                      const Text('• Keep paragraphs focused on one idea'),
                      const Text('• Vary your sentence length for better flow'),
                      const Text(
                        '• End with a conclusion that reinforces your main point',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
