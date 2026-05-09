import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../services/ai_service.dart';
import '../../services/storage_service.dart';
import '../../services/prompt_service.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  bool _hasPermission = false;
  bool _isPracticing = false;

  String _currentTopic = "";
  String _userSpeech = "";
  String _feedbackMessage = "";

  int _timerSeconds = 120; // 2 minutes
  Timer? _timer;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isPaused = false;
  String _wordsSpoken = "";
  String _finalSpeech = "";

  List<String> _topics = [
    "Tell me about a time you overcame a challenge",
    "What is your greatest strength and why?",
    "Describe a person who has influenced your life",
    "If you could travel anywhere, where would you go?",
    "What does success mean to you?",
    "Talk about a book that changed your perspective",
    "Describe your ideal day",
    "What is something you're passionate about?",
    "Share a lesson you learned from failure",
    "If you could have any superpower, what would it be?",
  ];

  final PromptService _promptService = PromptService();

  final TextEditingController _speechController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadPrompts();
  }

  Future<void> _loadPrompts() async {
    final firebasePrompts = await _promptService.getPrompts('speech');
    if (firebasePrompts.isNotEmpty) {
      setState(() {
        _topics = firebasePrompts;
        _generateRandomTopic(); // Re-generate with new topics
      });
    } else {
      _generateRandomTopic(); // Use hardcoded ones
    }
  }

  /// Initializing speech recognition
  void _initSpeech() async {
    // Request microphone permission explicitly first
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      _showError("Microphone permission is required for speech-to-text");
      return;
    }

    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            // Logic to handle if it stops listening unexpectedly
          }
        },
        onError: (errorNotification) {
          debugPrint('Speech error: $errorNotification');
          if (_isPracticing) {
            _showError("Speech recognition error: ${errorNotification.errorMsg}");
          }
        },
      );
      setState(() {});
    } catch (e) {
      debugPrint('Speech initialization failed: $e');
      _speechEnabled = false;
    }
  }

  void _generateRandomTopic() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _topics.length;
    setState(() {
      _currentTopic = _topics[randomIndex];
      _userSpeech = "";
      _feedbackMessage = "";
      _speechController.clear();
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
    if (!_speechEnabled) {
      _initSpeech();
    }

    setState(() {
      _isPracticing = true;
      _isPaused = false;
      _timerSeconds = 120;
      _userSpeech = "";
      _wordsSpoken = "";
      _finalSpeech = "";
      _feedbackMessage = "";
      _speechController.clear();
    });
    _startTimer();
    _startListening();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "🎤 Practice started! Speak on the topic.",
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(minutes: 2),
      cancelOnError: false,
      partialResults: true,
    );
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      // Append the current recognition to the previously finalized speech
      _speechController.text = _finalSpeech + _wordsSpoken;
    });
  }

  void _togglePause() {
    if (_isPaused) {
      // Resume
      setState(() {
        _isPaused = false;
      });
      _startTimer();
      _startListening();
    } else {
      // Pause
      _timer?.cancel();
      _stopListening();
      setState(() {
        _isPaused = true;
        // Finalize the current recognized words into _finalSpeech
        _finalSpeech = _speechController.text;
        // Add a space for the next segment if it doesn't end with one
        if (_finalSpeech.isNotEmpty && !_finalSpeech.endsWith(" ")) {
          _finalSpeech += " ";
        }
      });
    }
  }

  void _stopPractice() {
    _timer?.cancel();
    _stopListening();
    setState(() {
      _isPracticing = false;
      _isPaused = false;
      _userSpeech = _speechController.text;
    });
    
    // Record this session for analytics
    StorageService().recordSession();
    
    _generateFeedback();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Great job! Check your feedback below."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  bool _isGeneratingFeedback = false;
  final AIService _aiService = AIService();

  void _generateFeedback() async {
    final speech = _userSpeech;

    if (speech.isEmpty) {
      setState(() {
        _feedbackMessage = "⚠️ No speech recorded. Try typing your speech next time!";
      });
      return;
    }

    setState(() {
      _isGeneratingFeedback = true;
      _feedbackMessage = "🤖 Analyzing your speech with AI...";
    });

    try {
      final feedback = await _aiService.getFeedback(
        type: 'speech',
        topic: _currentTopic,
        content: speech,
      );

      setState(() {
        _feedbackMessage = feedback;
      });
    } catch (e) {
      setState(() {
        _feedbackMessage = "❌ Error generating feedback. Please try again later.";
      });
    } finally {
      setState(() {
        _isGeneratingFeedback = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speechController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Speech'),
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
                      colors: [
                        Colors.deepPurple.shade700,
                        Colors.deepPurple.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎯 Your Topic',
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
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: _isPracticing
                                  ? Colors.green.shade700
                                  : Colors.deepPurple.shade700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Action Buttons (Start/Stop/Pause)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isPracticing
                                  ? _stopPractice
                                  : _startPractice,
                              icon: Icon(
                                _isPracticing ? Icons.stop : Icons.play_arrow,
                              ),
                              label: Text(
                                _isPracticing
                                    ? 'Stop Practice'
                                    : 'Start Practice',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isPracticing
                                    ? Colors.red
                                    : Colors.deepPurple.shade700,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          if (_isPracticing) ...[
                            const SizedBox(width: 10),
                            IconButton.filled(
                              onPressed: _togglePause,
                              icon: Icon(
                                _isPaused ? Icons.play_arrow : Icons.pause,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: _isPaused
                                    ? Colors.green
                                    : Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(15),
                              ),
                              tooltip: _isPaused ? 'Resume' : 'Pause',
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),

                      if (_isPracticing)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _isPaused
                                ? Colors.orange.shade100
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _isPaused ? Colors.orange : Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isPaused
                                    ? 'Practice Paused'
                                    : 'Listening... Speak now!',
                                style: TextStyle(
                                  color: _isPaused ? Colors.orange : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Speech Input Card
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
                          Icon(Icons.edit_note, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Your Speech',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _speechController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: _isPracticing
                              ? (_isPaused
                                  ? "Practice paused. Resume to continue."
                                  : "Listening to your speech...")
                              : "Transcribed speech will appear here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tip: Your speech is automatically converted to text.',
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
                        if (_isGeneratingFeedback)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else
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
                          Icon(Icons.lightbulb, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Quick Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('• Read the topic carefully before starting'),
                      const Text('• Type your speech as you practice'),
                      const Text('• Aim for 2 minutes of speaking'),
                      const Text('• Review the AI feedback to improve'),
                      const Text('• Try new topics to build confidence'),
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
