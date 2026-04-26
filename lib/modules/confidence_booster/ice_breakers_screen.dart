import 'package:flutter/material.dart';

class IceBreakersScreen extends StatefulWidget {
  const IceBreakersScreen({super.key});

  @override
  State<IceBreakersScreen> createState() => _IceBreakersScreenState();
}

class _IceBreakersScreenState extends State<IceBreakersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;

  final List<String> _iceBreakers = [
    "What's the best thing that happened to you this week?",
    "If you could have any superpower, what would it be and why?",
    "What's a book or movie that completely changed your perspective?",
    "Are you working on any personal passion projects right now?",
    "What is something most people don't know about you?",
    "If you had to eat one meal for the rest of your life, what would it be?",
    "What is the most interesting place you've ever visited?",
    "Do you have any hidden talents?",
    "What's the best piece of advice you've ever received?",
    "If you could instantly become an expert in something, what would it be?",
  ];

  @override
  void initState() {
    super.initState();
    _iceBreakers.shuffle(); // Randomize the list for a fresh start
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextIceBreaker() {
    _controller.reset();
    setState(() {
      _currentIndex = (_currentIndex + 1) % _iceBreakers.length;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ice Breakers'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade50, Colors.deepPurple.shade50],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 60,
                  color: Colors.purple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Stuck in an awkward silence? Use this!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 150),
                      child: Center(
                        child: Text(
                          _iceBreakers[_currentIndex],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton.icon(
                  onPressed: _nextIceBreaker,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Next Prompt',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
