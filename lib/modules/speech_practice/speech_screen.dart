import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../services/ai_service.dart';
import '../../services/storage_service.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  bool _hasPermission = false;
  bool _isPracticing = false;
  bool _isListening = false;

  String _currentTopic = "";
  String _userSpeech = "";
  String _feedbackMessage = "";

  int _timerSeconds = 120; // 2 minutes
  Timer? _timer;

  final stt.SpeechToText _speech = stt.SpeechToText();
  String _lastWords = "";

  final List<String> _topics = [
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

  final TextEditingController _speechController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _generateRandomTopic();
  }

  Future<void> _initSpeech() async {
    final status = await Permission.microphone.request();
    bool available = false;
    
    if (status.isGranted) {
      available = await _speech.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'notListening' && _isPracticing) {
            // Keep listening if we are still practicing
            _startListening();
          }
        },
        onError: (errorNotification) => debugPrint('Error: $errorNotification'),
      );
    }

    setState(() {
      _hasPermission = status.isGranted && available;
    });

    if (!_hasPermission) {
      _showError("Microphone or Speech Recognition not available. Please check permissions.");
    }
  }

  void _generateRandomTopic() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _topics.length;
    setState(() {
      _currentTopic = _topics[randomIndex];
      _userSpeech = "";
      _lastWords = "";
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

  Future<void> _startListening() async {
    if (!_hasPermission) return;
    
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _lastWords = result.recognizedWords;
          _speechController.text = _userSpeech + (_userSpeech.isNotEmpty ? " " : "") + _lastWords;
        });
      },
      localeId: 'en_IN', // Specifically targeting Indian English accent
      listenMode: stt.ListenMode.dictation,
      cancelOnError: false,
      partialResults: true,
    );
    setState(() => _isListening = true);
  }

  void _startPractice() async {
    if (!_hasPermission) {
      await _initSpeech();
      if (!_hasPermission) return;
    }

    setState(() {
      _isPracticing = true;
      _timerSeconds = 120;
      _userSpeech = "";
      _lastWords = "";
      _feedbackMessage = "";
      _speechController.clear();
    });
    
    _startTimer();
    _startListening();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🎤 Recording started! Start speaking on the topic."),
        backgroundColor: Colors.deepPurple,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _stopPractice() async {
    _timer?.cancel();
    await _speech.stop();
    
    setState(() {
      _isPracticing = false;
      _isListening = false;
      _userSpeech = _speechController.text;
    });
    
    // Record this session for analytics
    StorageService().recordSession();
    
    _generateFeedback();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Practice stopped. Analyzing your speech..."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool _isGeneratingFeedback = false;
  final AIService _aiService = AIService();

  void _generateFeedback() async {
    final speech = _userSpeech;

    if (speech.isEmpty) {
      setState(() {
        _feedbackMessage = "⚠️ No speech detected. Please make sure your microphone is working and you are speaking clearly.";
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
    _speech.stop();
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
            onPressed: _isPracticing ? null : _generateRandomTopic,
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
                      // Timer/Mic Visualizer Display
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: _isPracticing
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : Colors.deepPurple.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (_isListening)
                            _PulseAnimation(
                              isListening: _isListening,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _isPracticing
                                  ? Colors.red.shade100
                                  : Colors.deepPurple.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isPracticing ? Icons.mic : Icons.mic_none,
                                    color: _isPracticing ? Colors.red : Colors.deepPurple,
                                  ),
                                  Text(
                                    _formatTime(_timerSeconds),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _isPracticing
                                          ? Colors.red.shade700
                                          : Colors.deepPurple.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Practice/Stop Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isPracticing
                              ? _stopPractice
                              : _startPractice,
                          icon: Icon(
                            _isPracticing ? Icons.stop : Icons.mic,
                          ),
                          label: Text(
                            _isPracticing ? 'Finish Speaking' : 'Start Speaking',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isPracticing
                                ? Colors.red
                                : Colors.deepPurple.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (_isPracticing)
                        Text(
                          'Listening for Indian English accent... 🇮🇳',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Speech Input Card (Transcription)
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
                          Icon(Icons.text_fields, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Live Transcription',
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
                        maxLines: 6,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _isPracticing
                              ? "Your words will appear here as you speak..."
                              : "No transcription yet.",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
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
                              'AI Analysis',
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
                            'Practice Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('• Speak clearly and at a moderate pace'),
                      const Text('• Stay close to the microphone'),
                      const Text('• The app is optimized for Indian accents'),
                      const Text('• AI will analyze your content and structure'),
                      const Text('• Try to fill the full 2 minutes'),
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

class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final bool isListening;

  const _PulseAnimation({required this.child, required this.isListening});

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
