import 'package:flutter/material.dart';

class SpeakingWarmupsScreen extends StatefulWidget {
  const SpeakingWarmupsScreen({super.key});

  @override
  State<SpeakingWarmupsScreen> createState() => _SpeakingWarmupsScreenState();
}

class _SpeakingWarmupsScreenState extends State<SpeakingWarmupsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _warmups = [
    {
      'title': 'The Jaw Relaxer',
      'instruction': 'Massage your cheeks and jaw joint softly, then let your mouth hang open completely relaxed for 5 seconds. Repeat 3 times.',
      'type': 'Physical',
    },
    {
      'title': 'Lip Trills (Motorboat)',
      'instruction': 'Blow air through your lips to make them flap together, sounding like a motorboat. Try gliding your voice up and down in pitch.',
      'type': 'Vocal',
    },
    {
      'title': 'Tongue Twister: Peter Piper',
      'instruction': 'Peter Piper picked a peck of pickled peppers.\nA peck of pickled peppers Peter Piper picked.\nIf Peter Piper picked a peck of pickled peppers,\nWhere\'s the peck of pickled peppers Peter Piper picked?',
      'type': 'Articulation',
    },
    {
      'title': 'Tongue Twister: Woodchuck',
      'instruction': 'How much wood would a woodchuck chuck if a woodchuck could chuck wood?\nHe would chuck, he would, as much as he could, and chuck as much wood as a woodchuck would if a woodchuck could chuck wood.',
      'type': 'Articulation',
    },
    {
      'title': 'The Siren',
      'instruction': 'Say "Ooo" and slide your voice from your lowest comfortable note to your highest, and back down again. Like a fire engine siren.',
      'type': 'Vocal',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaking Warmups'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.orange.shade50, Colors.yellow.shade50],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '${_currentPage + 1} of ${_warmups.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _warmups.length,
                itemBuilder: (context, index) {
                  final warmup = _warmups[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                warmup['type']!,
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              warmup['title']!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Text(
                              warmup['instruction']!,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade100,
                      foregroundColor: Colors.orange.shade900,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: _currentPage < _warmups.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Next'),
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
