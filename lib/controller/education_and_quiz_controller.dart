import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class EducationAndQuizController extends GetxController {
  // Quiz data
  var currentQuestionIndex = 0.obs;
  var selectedOption = ''.obs;
  var score = 0.obs;
  var quizCompleted = false.obs;
  var showExplanation = false.obs;
  var currentExplanation = ''.obs;
  List<Map<String, dynamic>> selectedQuestions = [];

  // Full questions bank
  final List<Map<String, dynamic>> allQuestions = [
    {
      'question': 'Which color code represents non-urgent cases in triage?',
      'options': ['Red', 'Blue', 'Yellow', 'Green'],
      'correctAnswer': 'Blue',
      'explanation': 'Blue represents non-urgent cases in veterinary triage systems. Red is critical, Yellow is urgent, Green is minor.',
    },
    {
      'question': 'Your dog suddenly starts choking. What should you do FIRST?',
      'options': [
        'Perform the Heimlich maneuver immediately',
        'Open their mouth to see if you can remove the object',
        'Hit them on the back forcefully',
        'Wait to see if they cough it up'
      ],
      'correctAnswer': 'Open their mouth to see if you can remove the object',
      'explanation': 'First try to safely open their mouth to see if the object is visible and removable. Avoid blindly sticking fingers in.',
    },
    {
      'question': 'Your cat ingests antifreeze. What\'s the MOST urgent action?',
      'options': [
        'Induce vomiting at home',
        'Rush to the vet immediately',
        'Give milk to dilute the poison',
        'Monitor for symptoms first'
      ],
      'correctAnswer': 'Rush to the vet immediately',
      'explanation': 'Antifreeze is deadly even in small amounts. Veterinary care is critical within 1-2 hours for the antidote.',
    },
    {
      'question': 'Your pet suffers heatstroke. What should you avoid doing?',
      'options': [
        'Cooling them with lukewarm water',
        'Offering ice-cold water to drink',
        'Moving them to a shaded area',
        'Placing a fan nearby'
      ],
      'correctAnswer': 'Offering ice-cold water to drink',
      'explanation': 'Avoid ice-cold water—it can shock their system. Use cool (not icy) water on paws, belly, and ears.',
    },
    {
      'question': 'A deep wound is bleeding heavily. What\'s the best temporary solution?',
      'options': [
        'Apply a tourniquet above the wound',
        'Press a clean cloth firmly over the wound',
        'Pour hydrogen peroxide on it',
        'Let it bleed to "clean out" the wound'
      ],
      'correctAnswer': 'Press a clean cloth firmly over the wound',
      'explanation': 'Apply direct pressure with clean cloth for 5-10 minutes. Tourniquets can cause tissue damage if done incorrectly.',
    },
    {
      'question': 'Your pet has a seizure. What should you do?',
      'options': [
        'Hold them down to prevent movement',
        'Put a spoon in their mouth to protect their tongue',
        'Time the seizure and clear the area of hazards',
        'Splash water on their face'
      ],
      'correctAnswer': 'Time the seizure and clear the area of hazards',
      'explanation': 'Never restrain or put objects in their mouth. Note seizure duration (if >2 minutes, emergency).',
    },
    {
      'question': 'You suspect a broken bone. How should you transport your pet?',
      'options': [
        'Carry them without supporting the injury',
        'Use a flat surface to minimize movement',
        'Let them walk to the car to avoid stress',
        'Apply a homemade splint tightly'
      ],
      'correctAnswer': 'Use a flat surface to minimize movement',
      'explanation': 'Stabilize the injury by limiting movement. Avoid DIY splints—incorrect pressure can worsen damage.',
    },
    {
      'question': 'Your pet is burned. What should you do first?',
      'options': [
        'Apply butter or oil to the burn',
        'Cover with a clean, dry dressing',
        'Apply ice directly to the burn',
        'Run cold water over the area for 10 minutes'
      ],
      'correctAnswer': 'Run cold water over the area for 10 minutes',
      'explanation': 'Cool the burn with room-temperature water. Never use ice, butter, or oil which can worsen tissue damage.',
    },
    {
      'question': 'What\'s the first sign of poisoning you might notice?',
      'options': [
        'Excessive drooling',
        'Sudden aggression',
        'Increased appetite',
        'Excessive energy'
      ],
      'correctAnswer': 'Excessive drooling',
      'explanation': 'Drooling is often the first sign, followed by vomiting, diarrhea, lethargy, or seizures.',
    },
    {
      'question': 'How should you approach an injured, frightened pet?',
      'options': [
        'Move quickly to restrain them',
        'Approach slowly while speaking calmly',
        'Make loud noises to get their attention',
        'Use treats to lure them to you'
      ],
      'correctAnswer': 'Approach slowly while speaking calmly',
      'explanation': 'Move slowly and avoid direct eye contact. Even friendly pets may bite when in pain or frightened.',
    },
    {
      'question': 'What temperature is considered a fever in dogs?',
      'options': [
        '100°F (37.8°C)',
        '101.5°F (38.6°C)',
        '103°F (39.4°C)',
        '99°F (37.2°C)'
      ],
      'correctAnswer': '103°F (39.4°C)',
      'explanation': 'Normal dog temperature is 101-102.5°F (38.3-39.2°C). Over 103°F indicates fever requiring veterinary attention.',
    },
    {
      'question': 'What should you do if your pet eats chocolate?',
      'options': [
        'Induce vomiting immediately',
        'Monitor for symptoms',
        'Call your vet or poison control',
        'Give activated charcoal'
      ],
      'correctAnswer': 'Call your vet or poison control',
      'explanation': 'The toxicity depends on the type/amount of chocolate and your pet\'s size. Always seek professional advice first.',
    },
    {
      'question': 'How can you check if your pet is dehydrated?',
      'options': [
        'Pinch their ear',
        'Check gum color',
        'Gently pull up their skin on the back',
        'Look at their eyes'
      ],
      'correctAnswer': 'Gently pull up their skin on the back',
      'explanation': 'Skin tenting test: Gently lift skin between shoulder blades. If it doesn\'t snap back quickly, they may be dehydrated.',
    },
    {
      'question': 'What\'s the most common household poison for pets?',
      'options': [
        'Chocolate',
        'Human medications',
        'Plants',
        'Cleaning products'
      ],
      'correctAnswer': 'Human medications',
      'explanation': 'Human medications (especially painkillers) are the most common pet poisonings, followed by human foods and plants.',
    },
    {
      'question': 'What should you include in a pet first-aid kit?',
      'options': [
        'Hydrogen peroxide',
        'Gauze and adhesive tape',
        'Aspirin',
        'All of the above'
      ],
      'correctAnswer': 'Gauze and adhesive tape',
      'explanation': 'Essential items: gauze, tape, thermometer, gloves, saline solution. Never give human meds without vet approval.',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    selectRandomQuestions();
  }

  void selectRandomQuestions() {
    final random = Random();
    final shuffled = List<Map<String, dynamic>>.from(allQuestions)..shuffle(random);
    selectedQuestions = shuffled.take(10).toList();
  }

  void selectOption(String option) {
    selectedOption.value = option;
    showExplanation.value = false;
  }

  void submitAnswer() {
    if (selectedOption.isEmpty) return;

    // Show explanation first
    if (!showExplanation.value) {
      currentExplanation.value = selectedQuestions[currentQuestionIndex.value]['explanation'];
      showExplanation.value = true;
      return;
    }

    // Check if answer is correct after showing explanation
    if (selectedOption.value == selectedQuestions[currentQuestionIndex.value]['correctAnswer']) {
      score.value += 1;
    }

    // Move to next question or complete quiz
    if (currentQuestionIndex.value < selectedQuestions.length - 1) {
      currentQuestionIndex.value += 1;
      selectedOption.value = '';
      showExplanation.value = false;
    } else {
      completeQuiz();
    }
  }

  Future<void> completeQuiz() async {
    quizCompleted.value = true;

    // Upload score to Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('quiz_results')
          .add({
        'userId': user.uid,
        'score': score.value,
        'totalQuestions': selectedQuestions.length,
        'timestamp': FieldValue.serverTimestamp(),
        'quizType': 'Pet Emergency',
      });
    }
  }

  double get progress => (currentQuestionIndex.value + 1) / selectedQuestions.length;
}