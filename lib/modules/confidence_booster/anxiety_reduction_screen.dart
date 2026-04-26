import 'package:flutter/material.dart';

class AnxietyReductionScreen extends StatelessWidget {
  const AnxietyReductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anxiety Reduction'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.pink.shade50],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Icon(
              Icons.self_improvement,
              size: 80,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Grounding Technique',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'The 5-4-3-2-1 method helps shift your focus from anxiety to your surroundings.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildGroundingStep(
              number: '5',
              title: 'Things you can SEE',
              description: 'Look around you and name five things you can see. It could be a pen, a spot on the ceiling, or a plant.',
              icon: Icons.visibility,
            ),
            _buildGroundingStep(
              number: '4',
              title: 'Things you can FEEL',
              description: 'Pay attention to your body and think of four things you can feel. The texture of your clothes, the temperature of the air, or the chair you are sitting on.',
              icon: Icons.touch_app,
            ),
            _buildGroundingStep(
              number: '3',
              title: 'Things you can HEAR',
              description: 'Listen carefully. Name three things you hear. The hum of the AC, birds outside, or distant traffic.',
              icon: Icons.hearing,
            ),
            _buildGroundingStep(
              number: '2',
              title: 'Things you can SMELL',
              description: 'Name two things you can smell. If you can\'t smell anything, focus on your favorite smells, like coffee or fresh rain.',
              icon: Icons.spa,
            ),
            _buildGroundingStep(
              number: '1',
              title: 'Thing you can TASTE',
              description: 'Focus on one thing you can taste. It might be toothpaste, a mint, or simply the inside of your mouth.',
              icon: Icons.coffee,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Take a slow, deep breath.\nYou are safe.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGroundingStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
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
}
