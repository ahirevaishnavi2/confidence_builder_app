class LearningSection {
  final String title;
  final String icon;
  final String description;
  final List<LearningItem> items;

  const LearningSection({
    required this.title,
    required this.icon,
    required this.description,
    required this.items,
  });
}

class LearningItem {
  final String title;
  final String content;
  final List<String> keyPoints;
  final String? tip;

  const LearningItem({
    required this.title,
    required this.content,
    required this.keyPoints,
    this.tip,
  });
}

class LearningHubData {
  static const List<LearningSection> sections = [
    LearningSection(
      title: 'Public Speaking Guides',
      icon: '🎤',
      description: 'Master the art of speaking confidently in public',
      items: [
        LearningItem(
          title: 'Conquering Stage Fright',
          content:
              'Stage fright is a natural physiological response to perceived threat. Your heart races, palms sweat — but these reactions are simply adrenaline preparing you to perform. The key is reframing this anxiety as excitement.',
          keyPoints: [
            'Arrive early and familiarize yourself with the space',
            'Practice slow, deep belly breathing before you speak',
            'Focus on your message, not on yourself',
            'Make eye contact with friendly faces in the audience',
            'Accept nervousness — it sharpens your focus',
          ],
          tip:
              'Pro Tip: The "Power Pose" — standing tall with hands on hips for 2 minutes — is shown to reduce cortisol and increase confidence.',
        ),
        LearningItem(
          title: 'Structuring a Compelling Speech',
          content:
              'Every memorable speech follows a clear structure. Without structure, even brilliant ideas get lost. The classic three-part framework — Opening, Body, Conclusion — remains the gold standard for a reason.',
          keyPoints: [
            'Opening: Hook → Context → Thesis (first 30 seconds are critical)',
            'Body: Present 2–3 key ideas with supporting examples',
            'Use transitions to guide the audience seamlessly',
            'Conclusion: Summarize, reinforce your message, and call to action',
            'Practice the opening and closing until they\'re perfect',
          ],
          tip:
              'Pro Tip: Start with a surprising statistic, a provocative question, or a short story — never start with an apology.',
        ),
        LearningItem(
          title: 'Engaging Your Audience',
          content:
              'A great speaker does not just deliver information — they create a two-way experience. Audience engagement transforms a presentation into a conversation, keeping attention focused and messages memorable.',
          keyPoints: [
            'Ask rhetorical or direct questions regularly',
            'Use personal anecdotes and relatable stories',
            'Vary your pace — slow down for emphasis, speed up for energy',
            'Use pauses powerfully — silence commands attention',
            'Involve the audience through polls or show-of-hands moments',
          ],
          tip:
              'Pro Tip: The "Rule of Three" — presenting ideas in groups of three — makes information naturally memorable and satisfying.',
        ),
      ],
    ),
    LearningSection(
      title: 'Body Language Tips',
      icon: '🧍',
      description: 'Communicate powerfully without saying a word',
      items: [
        LearningItem(
          title: 'Posture and Presence',
          content:
              'Studies suggest that over 55% of communication is nonverbal. Your posture, stance, and physical presence send powerful signals before you even speak. Commanding presence begins with how you hold your body.',
          keyPoints: [
            'Stand with feet shoulder-width apart — grounded and stable',
            'Keep shoulders back, chest open — signals confidence',
            'Avoid crossing arms — it appears defensive',
            'Do not lean on the podium or fidget with objects',
            'Move with intention — deliberate movement signals authority',
          ],
          tip:
              'Pro Tip: Imagine a string pulling the crown of your head toward the ceiling — this naturally aligns your posture.',
        ),
        LearningItem(
          title: 'Eye Contact & Facial Expressions',
          content:
              'Eye contact builds trust, shows confidence, and creates connection. Avoiding it signals discomfort or dishonesty. Similarly, your facial expressions should mirror your message — congruence between words and expressions is powerful.',
          keyPoints: [
            'Hold eye contact for 3–5 seconds per person, then move on',
            'Do not scan the room nervously — it signals anxiety',
            'Smile genuinely — it creates warmth and approachability',
            'Raise eyebrows slightly when making an important point',
            'Match your expression to your emotional content',
          ],
          tip:
              'Pro Tip: Divide the audience into sections and give deliberate eye contact to each section throughout your talk.',
        ),
        LearningItem(
          title: 'Gestures That Amplify Your Message',
          content:
              'Natural, purposeful gestures reinforce your words and help the audience visualize your ideas. The goal is to appear natural and expansive — not scripted or erratic.',
          keyPoints: [
            'Keep gestures within the "power zone" — waist to shoulders',
            'Open palms signal honesty and openness',
            'Use numbers on fingers to emphasize key points',
            'Avoid pointing — it feels aggressive; use open hand instead',
            'Let gestures flow naturally — don\'t force or suppress them',
          ],
          tip:
              'Pro Tip: Record yourself speaking and review your gestures — you will quickly notice what feels natural versus mechanical.',
        ),
      ],
    ),
    LearningSection(
      title: 'Presentation Skills',
      icon: '📊',
      description: 'Deliver impactful presentations that are remembered',
      items: [
        LearningItem(
          title: 'Designing Slides That Support, Not Distract',
          content:
              'Your slides are a visual aid, not a script. Audiences read or listen — they cannot do both at once. Great slides amplify your spoken words without replacing them.',
          keyPoints: [
            'One key idea per slide — maximum clarity',
            'Use the 6x6 rule: no more than 6 bullets, 6 words each',
            'High-contrast color: dark background, light text (or vice versa)',
            'Use visuals, charts, or images instead of blocks of text',
            'Consistent fonts, spacing, and layout throughout',
          ],
          tip:
              'Pro Tip: Can your key message be understood from your slide in under 5 seconds? If not, simplify it.',
        ),
        LearningItem(
          title: 'Handling Q&A Sessions Confidently',
          content:
              'Many speakers fear the Q&A more than the presentation itself. Yet it is a golden opportunity to demonstrate expertise and build deeper connection with your audience.',
          keyPoints: [
            'Listen to the full question before formulating a response',
            'Repeat or rephrase the question for the full audience',
            'It is perfectly fine to say "That\'s a great question — let me think."',
            'Redirect outside-scope questions: "I\'ll connect with you after."',
            'Stay calm with hostile questions — do not get defensive',
          ],
          tip:
              'Pro Tip: Prepare 5 likely questions in advance. When you anticipate questions, you answer more fluently and confidently.',
        ),
        LearningItem(
          title: 'Virtual Presentation Excellence',
          content:
              'Presenting virtually requires all the skills of in-person speaking — plus additional technical awareness. The camera is your audience\'s eyes, and your energy must travel through a screen.',
          keyPoints: [
            'Position the camera at eye level — never looking up or down',
            'Ensure strong, even lighting — avoid backlighting',
            'Look INTO the camera, not at your own video feed',
            'Speak slightly slower and more deliberately than in person',
            'Test all tech at least 30 minutes before your session',
          ],
          tip:
              'Pro Tip: Place a sticky note next to your camera with key talking points so your eyes stay near the lens.',
        ),
      ],
    ),
    LearningSection(
      title: 'Group Discussion Strategies',
      icon: '💬',
      description: 'Shine in GDs, team meetings, and collaborative settings',
      items: [
        LearningItem(
          title: 'Making a Strong First Impression in GDs',
          content:
              'The first 60 seconds of a group discussion often set the tone. How you initiate, your tone of voice, and your first contribution signal your confidence and communication style to evaluators and peers.',
          keyPoints: [
            'Initiate the discussion confidently with a clear framing statement',
            'Summarize the topic before diving into your point',
            'Speak clearly and at a measured pace — no rushing',
            'Use inclusive language: "As a group, we might consider..."',
            'Avoid interrupting — wait for a natural pause to contribute',
          ],
          tip:
              'Pro Tip: Initiating a GD well is +1 advantage, but listen first if you need a moment to collect your thoughts.',
        ),
        LearningItem(
          title: 'Balancing Assertiveness and Listening',
          content:
              'The best GD participants are not the loudest — they are the most coherent and balanced. Contributing thoughtful insights while genuinely listening to others marks true leadership communication.',
          keyPoints: [
            'Take concise notes while others speak to reference later',
            'Build on others\' points: "Adding to what Priya said..."',
            'Disagree respectfully: "I see it differently — here\'s why..."',
            'Avoid monopolizing — quality over quantity of contributions',
            'Bring quieter members in: "Rajesh, what\'s your take?"',
          ],
          tip:
              'Pro Tip: In a GD assessment context, the person who manages group dynamics is often rated highest — not the one who spoke most.',
        ),
        LearningItem(
          title: 'Concluding a Group Discussion',
          content:
              'A well-delivered conclusion demonstrates synthesis, leadership, and clear thinking. Even if the group has diverse viewpoints, you can tie everything together in a balanced, structured close.',
          keyPoints: [
            'Signal the close: "To summarize the key points we\'ve covered..."',
            'Acknowledge multiple valid perspectives presented',
            'Highlight areas of consensus reached by the group',
            'Offer a clear, balanced final recommendation or insight',
            'End with a constructive, forward-looking statement',
          ],
          tip:
              'Pro Tip: Practice summarizing in 60 seconds. This skill — distilling complex discussions into crisp summaries — is rare and impressive.',
        ),
      ],
    ),
    LearningSection(
      title: 'Debate Techniques',
      icon: '⚖️',
      description: 'Argue persuasively, logically, and with grace',
      items: [
        LearningItem(
          title: 'Building a Watertight Argument',
          content:
              'Persuasion in debate is not about passion — it is about the quality of your argument and evidence. The classic Claim → Evidence → Reasoning framework provides a bulletproof structure for any position.',
          keyPoints: [
            'State your Claim clearly and without ambiguity',
            'Support with verifiable Evidence: data, examples, expert quotes',
            'Explain your Reasoning — how does evidence support the claim?',
            'Anticipate counter-arguments and address them preemptively',
            'Maintain logical consistency throughout your argument',
          ],
          tip:
              'Pro Tip: "Steel-manning" — presenting the strongest version of the opposing view before rebutting it — signals intellectual honesty and impresses judges.',
        ),
        LearningItem(
          title: 'Effective Rebuttal Techniques',
          content:
              'Rebuttal is where debates are won and lost. The ability to listen carefully, identify flaws in reasoning, and respond crisply under pressure is a hallmark of an elite debater.',
          keyPoints: [
            'Attack the argument, never the person — stay logical',
            'Identify the specific flaw: false premise, weak evidence, or logical fallacy',
            'Use "Yes, but..." to acknowledge partial truth before countering',
            'Be concise — a sharp 3-sentence rebuttal beats a rambling one',
            'Stay composed — emotional reactions weaken your credibility',
          ],
          tip:
              'Pro Tip: Practice rapid-fire rebuttals by watching debates on YouTube and pausing to rehearse your counter — out loud.',
        ),
        LearningItem(
          title: 'Maintaining Composure Under Pressure',
          content:
              'Debate environments are designed to challenge your composure. The debater who remains calm, measured, and even-keeled under pressure invariably appears more credible than one who becomes agitated.',
          keyPoints: [
            'Control your breathing — it governs your emotional state',
            'Pause before responding — it signals thoughtfulness',
            'Use humor wisely — levity can defuse tension effectively',
            'Acknowledge a good point from the opposition graciously',
            'Your credibility is built over the whole debate, not just one moment',
          ],
          tip:
              'Pro Tip: If attacked unfairly, respond with measured calm: "I appreciate the passion, though I\'d ask us to focus on the argument." This wins the room.',
        ),
      ],
    ),
    LearningSection(
      title: 'Professional Communication',
      icon: '💼',
      description: 'Communicate effectively in workplace and business settings',
      items: [
        LearningItem(
          title: 'Email Etiquette & Writing',
          content:
              'In professional settings, your emails represent you. A well-written email communicates competence, respect, and clarity. Poorly written emails create confusion and undermine your professional image.',
          keyPoints: [
            'Clear subject line that states the purpose immediately',
            'Open with context — why are you writing this email?',
            'One primary request or point per email where possible',
            'Use bullet points for multiple action items or information',
            'Proofread every email before hitting send — always',
          ],
          tip:
              'Pro Tip: Read your email aloud before sending. If it sounds awkward spoken, it will read awkwardly too.',
        ),
        LearningItem(
          title: 'Navigating Difficult Conversations',
          content:
              'Difficult conversations — feedback, disagreements, or delivering bad news — are inevitable in any workplace. How you navigate them determines your credibility as a communicator and leader.',
          keyPoints: [
            'Prepare: know your key points and the desired outcome',
            'Start with empathy — acknowledge the other person\'s perspective',
            'Use "I" statements: "I feel..." not "You always..."',
            'Stay curious, not combative — ask questions to understand',
            'Focus on the issue, never make it personal',
          ],
          tip:
              'Pro Tip: The SBI Framework — Situation, Behavior, Impact — provides a neutral, fact-based structure for any feedback conversation.',
        ),
        LearningItem(
          title: 'Building Executive Presence',
          content:
              'Executive presence is that intangible quality that makes leaders stand out in any room. It is a combination of communication confidence, gravitas, and the ability to inspire trust through every interaction.',
          keyPoints: [
            'Speak with conviction — eliminate filler words (um, uh, like)',
            'Be brief and direct — do not bury the key message',
            'Ask insightful questions — they signal deep understanding',
            'Project calm confidence under pressure — especially publicly',
            'Be consistent — executive presence is built over many interactions',
          ],
          tip:
              'Pro Tip: Replace "I think" or "Maybe" with "In my view" or "I recommend" — subtle language shifts that signal authority and ownership.',
        ),
      ],
    ),
  ];
}
