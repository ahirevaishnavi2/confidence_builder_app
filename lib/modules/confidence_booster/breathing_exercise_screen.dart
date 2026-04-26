import 'dart:async';
import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  String _instructionText = 'Ready';
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 100.0, end: 250.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startBreathingCycle() {
    setState(() {
      _isActive = true;
    });
    _runInhale();
  }
  
  void _stopBreathingCycle() {
    _timer?.cancel();
    _controller.stop();
    _controller.reset();
    setState(() {
      _isActive = false;
      _instructionText = 'Ready';
      _secondsRemaining = 0;
    });
  }

  void _runInhale() {
    if (!mounted || !_isActive) return;
    setState(() {
      _instructionText = 'Inhale';
      _secondsRemaining = 4;
    });
    _controller.duration = const Duration(seconds: 4);
    _controller.forward();
    _startTimer(4, _runHold);
  }

  void _runHold() {
    if (!mounted || !_isActive) return;
    setState(() {
      _instructionText = 'Hold';
      _secondsRemaining = 7;
    });
    // the circle stays expanded
    _startTimer(7, _runExhale);
  }

  void _runExhale() {
    if (!mounted || !_isActive) return;
    setState(() {
      _instructionText = 'Exhale';
      _secondsRemaining = 8;
    });
    _controller.duration = const Duration(seconds: 8);
    _controller.reverse();
    _startTimer(8, _runInhale); // Loop back
  }

  void _startTimer(int seconds, VoidCallback onComplete) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isActive) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          onComplete();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Breathing'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.teal.shade50],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '4-7-8 Breathing Technique',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Follow the prompt to relax your nervous system.',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 80),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: _animation.value,
                  height: _animation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade200.withValues(alpha: 0.6),
                    border: Border.all(color: Colors.blue.shade400, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _instructionText,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        if (_isActive && _secondsRemaining > 0)
                          Text(
                            '$_secondsRemaining s',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue.shade800,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: _isActive ? _stopBreathingCycle : _startBreathingCycle,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isActive ? Colors.red.shade400 : Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _isActive ? 'Stop' : 'Start Breathing',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
