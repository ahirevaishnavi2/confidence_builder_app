import '../models/vocabulary_model.dart';

class VocabularyData {
  static const String wordOfTheDay = 'Perspicacious';
  static const String wordOfTheDayMeaning =
      'Having a ready insight into things; shrewd and discerning.';
  static const String wordOfTheDaySynonym = 'Shrewd, Astute, Discerning';
  static const String wordOfTheDayExample =
      'The perspicacious investor identified the market trend before anyone else.';

  static const String quoteOfTheDay =
      '"The limits of my language mean the limits of my world." — Ludwig Wittgenstein';

  static final List<VocabularyWord> allWords = [
    // Interview
    VocabularyWord(
      id: 'i1',
      word: 'Proficiency',
      meaning: 'A high degree of competence or skill in a particular area.',
      synonym: 'Expertise, Mastery, Competence',
      exampleSentence:
          'Her proficiency in data analysis made her the top candidate.',
      category: 'Interview',
    ),
    VocabularyWord(
      id: 'i2',
      word: 'Synergy',
      meaning:
          'The interaction of two or more elements to produce a combined effect greater than the sum of their parts.',
      synonym: 'Collaboration, Cooperation, Combined effort',
      exampleSentence:
          'The synergy between the design and engineering teams led to an outstanding product.',
      category: 'Interview',
    ),
    VocabularyWord(
      id: 'i3',
      word: 'Leverage',
      meaning: 'Use something to maximum advantage.',
      synonym: 'Utilize, Exploit, Capitalize on',
      exampleSentence:
          'We can leverage our existing client base to launch the new service.',
      category: 'Interview',
    ),
    VocabularyWord(
      id: 'i4',
      word: 'Proactive',
      meaning:
          'Creating or controlling a situation rather than just responding to it.',
      synonym: 'Anticipatory, Forward-thinking, Initiative-taking',
      exampleSentence:
          'A proactive approach to problem-solving sets great employees apart.',
      category: 'Interview',
    ),
    VocabularyWord(
      id: 'i5',
      word: 'Acumen',
      meaning:
          'The ability to make good judgments and quick decisions in a particular domain.',
      synonym: 'Sharpness, Astuteness, Insight',
      exampleSentence:
          'Her business acumen impressed the interviewers tremendously.',
      category: 'Interview',
    ),

    // Business
    VocabularyWord(
      id: 'b1',
      word: 'Paradigm Shift',
      meaning: 'A fundamental change in approach or underlying assumptions.',
      synonym: 'Revolution, Transformation, Sea change',
      exampleSentence:
          'Remote work represents a paradigm shift in how companies operate.',
      category: 'Business',
    ),
    VocabularyWord(
      id: 'b2',
      word: 'Scalable',
      meaning:
          'Able to be changed in size or scale; capable of being easily expanded.',
      synonym: 'Expandable, Adaptable, Flexible',
      exampleSentence: 'We need a scalable solution that grows with our needs.',
      category: 'Business',
    ),
    VocabularyWord(
      id: 'b3',
      word: 'Bandwidth',
      meaning:
          'The capacity to handle a task or project (in professional context).',
      synonym: 'Capacity, Availability, Resources',
      exampleSentence:
          'I don\'t have the bandwidth to take on another project this quarter.',
      category: 'Business',
    ),
    VocabularyWord(
      id: 'b4',
      word: 'Stakeholder',
      meaning:
          'A person or group with an interest or concern in an organization or project.',
      synonym: 'Interested party, Participant, Investor',
      exampleSentence:
          'We must align all stakeholders before proceeding with the new strategy.',
      category: 'Business',
    ),
    VocabularyWord(
      id: 'b5',
      word: 'Disruptive',
      meaning:
          'Causing radical change to an existing industry, market, or technology.',
      synonym: 'Innovative, Revolutionary, Ground-breaking',
      exampleSentence:
          'Disruptive technologies are transforming traditional banking.',
      category: 'Business',
    ),

    // Daily Use
    VocabularyWord(
      id: 'd1',
      word: 'Articulate',
      meaning:
          'Having or showing the ability to speak fluently and coherently.',
      synonym: 'Eloquent, Fluent, Well-spoken',
      exampleSentence:
          'She was articulate in expressing her concerns to the manager.',
      category: 'Daily Use',
    ),
    VocabularyWord(
      id: 'd2',
      word: 'Empathy',
      meaning:
          'The ability to understand and share the feelings of another person.',
      synonym: 'Compassion, Understanding, Sympathy',
      exampleSentence:
          'Empathy is the foundation of meaningful human connection.',
      category: 'Daily Use',
    ),
    VocabularyWord(
      id: 'd3',
      word: 'Resilient',
      meaning:
          'Able to withstand or recover quickly from difficult conditions.',
      synonym: 'Tough, Adaptable, Strong',
      exampleSentence:
          'Being resilient during setbacks is the hallmark of success.',
      category: 'Daily Use',
    ),
    VocabularyWord(
      id: 'd4',
      word: 'Diligent',
      meaning: 'Having or showing care and conscientiousness in work or duties.',
      synonym: 'Hardworking, Assiduous, Industrious',
      exampleSentence: 'A diligent student reviews notes every evening.',
      category: 'Daily Use',
    ),
    VocabularyWord(
      id: 'd5',
      word: 'Candid',
      meaning: 'Truthful and straightforward; frank.',
      synonym: 'Frank, Honest, Open',
      exampleSentence:
          'I appreciate your candid feedback — it helps me improve.',
      category: 'Daily Use',
    ),

    // Public Speaking
    VocabularyWord(
      id: 'p1',
      word: 'Rhetoric',
      meaning:
          'The art of effective or persuasive speaking or writing, especially the use of figures of speech.',
      synonym: 'Oratory, Eloquence, Persuasion',
      exampleSentence:
          'His powerful rhetoric moved the audience to take immediate action.',
      category: 'Public Speaking',
    ),
    VocabularyWord(
      id: 'p2',
      word: 'Gravitas',
      meaning:
          'Dignity, seriousness, or solemn manner, especially in a person\'s bearing.',
      synonym: 'Dignity, Weight, Solemnity',
      exampleSentence:
          'The CEO delivered the announcement with remarkable gravitas.',
      category: 'Public Speaking',
    ),
    VocabularyWord(
      id: 'p3',
      word: 'Cadence',
      meaning:
          'The rhythmic rise and fall of speech; the modulation of voice tone.',
      synonym: 'Rhythm, Tempo, Flow',
      exampleSentence:
          'Her natural cadence made her speech captivating to listen to.',
      category: 'Public Speaking',
    ),
    VocabularyWord(
      id: 'p4',
      word: 'Impromptu',
      meaning:
          'Done without preparation; a speech made with little or no preparation.',
      synonym: 'Spontaneous, Unrehearsed, Off-the-cuff',
      exampleSentence:
          'She delivered an impressive impromptu speech at the conference.',
      category: 'Public Speaking',
    ),
    VocabularyWord(
      id: 'p5',
      word: 'Enunciation',
      meaning: 'The act of pronouncing words clearly and distinctly.',
      synonym: 'Diction, Articulation, Pronunciation',
      exampleSentence:
          'Clear enunciation is essential when speaking to a large audience.',
      category: 'Public Speaking',
    ),

    // Professional Communication
    VocabularyWord(
      id: 'c1',
      word: 'Concise',
      meaning: 'Giving a lot of information clearly and in few words.',
      synonym: 'Brief, Succinct, Terse',
      exampleSentence:
          'A concise email is more effective than a long, rambling one.',
      category: 'Professional Communication',
    ),
    VocabularyWord(
      id: 'c2',
      word: 'Assertive',
      meaning:
          'Having or showing a confident and forceful personality; confident.',
      synonym: 'Confident, Self-assured, Decisive',
      exampleSentence:
          'Be assertive in meetings — your ideas deserve to be heard.',
      category: 'Professional Communication',
    ),
    VocabularyWord(
      id: 'c3',
      word: 'Diplomatic',
      meaning:
          'Having and showing skill in dealing with people in sensitive situations.',
      synonym: 'Tactful, Discreet, Judicious',
      exampleSentence:
          'A diplomatic response defuses tension without dismissing concerns.',
      category: 'Professional Communication',
    ),
    VocabularyWord(
      id: 'c4',
      word: 'Transparent',
      meaning:
          'Open to public scrutiny; not hiding thoughts, feelings, or information.',
      synonym: 'Open, Honest, Forthright',
      exampleSentence:
          'Transparent communication builds trust within a team.',
      category: 'Professional Communication',
    ),
    VocabularyWord(
      id: 'c5',
      word: 'Constructive',
      meaning:
          'Serving a useful purpose; tending to build up or improve.',
      synonym: 'Helpful, Positive, Productive',
      exampleSentence:
          'Offer constructive criticism rather than vague complaints.',
      category: 'Professional Communication',
    ),
  ];

  static const List<ReadingSnippet> readingSnippets = [
    ReadingSnippet(
      title: 'The Power of Persuasion',
      content:
          'In today\'s competitive world, the ability to communicate persuasively is an invaluable skill. A truly eloquent speaker does not merely convey information — they inspire action. By understanding the psychology of their audience and choosing words with precision, they create a profound impact. The most sagacious leaders throughout history have leveraged the power of rhetoric to rally their followers and articulate a compelling vision for the future.',
      highlightedWords: ['eloquent', 'profound', 'sagacious', 'rhetoric', 'articulate'],
      source: 'Communication Excellence Series',
    ),
    ReadingSnippet(
      title: 'Building Professional Confidence',
      content:
          'Confidence in a professional setting is not an innate trait — it is a skill cultivated through deliberate practice and a resilient mindset. Individuals who appear self-assured in the boardroom have often overcome significant obstacles to develop that composure. The key lies in being proactive: preparing thoroughly, seeking candid feedback, and embracing a growth-oriented perspective that transforms every setback into a learning opportunity.',
      highlightedWords: ['innate', 'resilient', 'self-assured', 'proactive', 'candid'],
      source: 'Leadership Mindset Quarterly',
    ),
    ReadingSnippet(
      title: 'The Art of Active Listening',
      content:
          'Effective communication is only half speaking — the other half is listening with empathy and intention. Active listening requires you to be fully present, to acknowledge the speaker\'s perspective with perspicacity, and to respond thoughtfully rather than reactively. This nuanced skill transforms ordinary conversations into meaningful exchanges, and is one of the most coveted competencies in both professional and personal relationships.',
      highlightedWords: ['empathy', 'perspicacity', 'nuanced', 'coveted', 'competencies'],
      source: 'Professional Development Weekly',
    ),
  ];

  static const List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      question: 'What does "Eloquent" mean?',
      options: [
        'Fluent and persuasive in speaking',
        'Extremely loud voice',
        'Very precise and technical',
        'Shy and reserved',
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Which word means "having sharp insight or keen judgement"?',
      options: ['Candid', 'Resilient', 'Perspicacious', 'Scalable'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: 'What is the meaning of "Gravitas"?',
      options: [
        'Speaking very fast',
        'Seriousness and dignity of manner',
        'A type of public speech',
        'Feeling nervous before a presentation',
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Which word best fits: "She was ___ in expressing her ideas — clear, direct, and confident."',
      options: ['Impromptu', 'Disruptive', 'Assertive', 'Scalable'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: 'What does "Cadence" refer to in public speaking?',
      options: [
        'The volume of your voice',
        'The rhythm and flow of speech',
        'The choice of vocabulary',
        'Maintaining eye contact',
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'What is a synonym for "Concise"?',
      options: ['Verbose', 'Succinct', 'Prolix', 'Elaborate'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '"Acumen" means:',
      options: [
        'A formal business presentation',
        'Fear of public speaking',
        'Keen ability to judge a situation quickly',
        'A type of professional certification',
      ],
      correctIndex: 2,
    ),
  ];
}
