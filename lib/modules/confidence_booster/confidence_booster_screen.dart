import 'package:flutter/material.dart';
import 'anxiety_reduction_screen.dart';
import 'breathing_exercise_screen.dart';
import 'confidence_checklist_screen.dart';
import 'ice_breakers_screen.dart';
import 'speaking_warmups_screen.dart';

class ConfidenceBoosterScreen extends StatelessWidget {
  const ConfidenceBoosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confidence Booster'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade50, Colors.deepPurple.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Quick Support Toolkit',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select a tool to help you relax and feel prepared right now.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildToolCard(
                      context,
                      'Guided Breathing',
                      'Calm your nervous system with timed breathing.',
                      Icons.air,
                      Colors.blue,
                      const BreathingExerciseScreen(),
                    ),
                    _buildToolCard(
                      context,
                      'Speaking Warmups',
                      'Get your voice ready with quick exercises.',
                      Icons.mic,
                      Colors.orange,
                      const SpeakingWarmupsScreen(),
                    ),
                    _buildToolCard(
                      context,
                      'Confidence Checklist',
                      'Review you are ready to go.',
                      Icons.check_circle_outline,
                      Colors.green,
                      const ConfidenceChecklistScreen(),
                    ),
                    _buildToolCard(
                      context,
                      'Ice Breakers',
                      'Conversation starters for any social setting.',
                      Icons.handshake,
                      Colors.purple,
                      const IceBreakersScreen(),
                    ),
                    _buildToolCard(
                      context,
                      'Anxiety Reduction',
                      'Grounding techniques to reduce panic.',
                      Icons.favorite_border,
                      Colors.red,
                      const AnxietyReductionScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    Widget destinationScreen,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
