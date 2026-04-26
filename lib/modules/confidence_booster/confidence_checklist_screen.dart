import 'package:flutter/material.dart';

class ConfidenceChecklistScreen extends StatefulWidget {
  const ConfidenceChecklistScreen({super.key});

  @override
  State<ConfidenceChecklistScreen> createState() =>
      _ConfidenceChecklistScreenState();
}

class _ConfidenceChecklistScreenState extends State<ConfidenceChecklistScreen> {
  final List<Map<String, dynamic>> _checklistItems = [
    {
      'task': 'I know my material / key talking points.',
      'isChecked': false,
    },
    {
      'task': 'I have taken 3 deep, grounding breaths.',
      'isChecked': false,
    },
    {
      'task': 'My posture is upright and open.',
      'isChecked': false,
    },
    {
      'task': 'I have a glass of water nearby if needed.',
      'isChecked': false,
    },
    {
      'task': 'I am dressed comfortably and appropriately.',
      'isChecked': false,
    },
    {
      'task': 'I remember that it is okay to pause and think.',
      'isChecked': false,
    },
    {
      'task': 'I am ready to share my thoughts, not aim for perfection.',
      'isChecked': false,
    },
  ];

  double get _progress {
    int checkedCount = _checklistItems.where((item) => item['isChecked']).length;
    return checkedCount / _checklistItems.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-Event Checklist'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.teal.shade50],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Readiness Check',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.green.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade800),
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_progress * 100).toInt()}% Prepared',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _checklistItems.length,
                itemBuilder: (context, index) {
                  final item = _checklistItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        item['task'],
                        style: TextStyle(
                          fontSize: 16,
                          decoration: item['isChecked']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: item['isChecked']
                              ? Colors.grey.shade600
                              : Colors.black87,
                        ),
                      ),
                      value: item['isChecked'],
                      activeColor: Colors.green.shade600,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setState(() {
                          _checklistItems[index]['isChecked'] = value ?? false;
                        });
                        
                        if (_progress == 1.0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You are 100% ready! You got this! 🌟'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            if (_progress == 1.0)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'I\'m Ready to Go!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
