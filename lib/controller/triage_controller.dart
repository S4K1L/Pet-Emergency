import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TriageStep { species, complaint, questions, result }

class TriageController extends GetxController {
  // Step 1: Species selection
  var speciesList = ['Dog', 'Cat', 'Other'].obs;
  var selectedSpecies = ''.obs;

  // Step 2: Complaint selection
  var complaintList = [
    'Breathing issues',
    'Collapse',
    'Trauma',
    'Vomiting',
    'Bleeding',
    'Seizures',
    'Poisoning',
    'Eye problems'
  ].obs;
  var selectedComplaint = ''.obs;

  // Step 3: Questions flow
  var currentQuestion = ''.obs;
  var questionIndex = 0.obs;
  var questions = <String>[].obs;

  // Step 4-5: Results
  var triageResult = ''.obs;
  var suggestedAction = ''.obs;
  var currentStep = TriageStep.species.obs;

  final Map<String, List<String>> _complaintQuestions = {
    'Breathing issues': [
      'Is the animal gasping or cyanotic (blue gums)?',
      'Is breathing rapid or labored?',
      'Has this been going on for more than 30 minutes?'
    ],
    'Collapse': [
      'Is the animal unconscious?',
      'Is there a seizure or twitching?',
      'Is the animal able to stand?'
    ],
    'Trauma': [
      'Is there severe bleeding?',
      'Are there visible fractures?',
      'Is the animal responsive to you?'
    ],
    'Vomiting': [
      'Is there blood in vomit?',
      'Has vomiting occurred more than 3 times?',
      'Is the animal lethargic or weak?'
    ],
    'Bleeding': [
      'Is bleeding uncontrolled (soaking through bandages)?',
      'Is there pale gums?',
      'Is there history of trauma?'
    ],
    'Seizures': [
      'Is the seizure ongoing (more than 2 minutes)?',
      'Is this the first seizure?',
      'Is the animal conscious between seizures?'
    ],
    'Poisoning': [
      'Did ingestion occur within the last 30 minutes?',
      'Is the animal showing symptoms?',
      'Do you know what was ingested?'
    ],
    'Eye problems': [
      'Is the eye bulging or displaced?',
      'Is there significant swelling?',
      'Did this happen suddenly?'
    ]
  };

  final Map<String, List<String>> _resultMapping = {
    'Breathing issues': [
      'Red: Critical - Respiratory distress',
      'Yellow: Urgent - Breathing difficulties',
      'Green: Monitor - Mild symptoms'
    ],
    'Collapse': [
      'Red: Critical - Unconscious',
      'Yellow: Urgent - Weakness/Collapse',
      'Green: Stable - Able to stand'
    ],
    // Add similar mappings for other complaints
  };

  void selectSpecies(String species) {
    selectedSpecies.value = species;
    currentStep.value = TriageStep.complaint;
  }

  void selectComplaint(String complaint) {
    selectedComplaint.value = complaint;
    questions.value = _complaintQuestions[complaint] ?? [];
    questionIndex.value = 0;

    if (questions.isNotEmpty) {
      currentQuestion.value = questions[0];
      currentStep.value = TriageStep.questions;
    } else {
      // Skip to result if no questions for this complaint
      generateResult([]);
    }
  }

  void answerQuestion(bool isYes) {
    if (isYes) {
      // If yes to any critical question (usually first one), immediate red
      if (questionIndex.value == 0) {
        generateResult([true]);
        return;
      }
    }

    if (questionIndex.value < questions.length - 1) {
      questionIndex.value++;
      currentQuestion.value = questions[questionIndex.value];
    } else {
      // All questions answered
      generateResult([isYes]);
    }
  }

  void generateResult(List<bool> answers) {
    // Simplified logic - in real app this would be more sophisticated
    if (answers.contains(true)) {
      if (answers.firstWhere((a) => a, orElse: () => false)) {
        triageResult.value = 'Red: Critical Emergency';
        suggestedAction.value = 'Seek veterinary care IMMEDIATELY. Call ahead if possible.';
      } else {
        triageResult.value = 'Yellow: Urgent Care Needed';
        suggestedAction.value = 'See a veterinarian within 2-4 hours. Monitor closely.';
      }
    } else {
      triageResult.value = 'Green: Stable Condition';
      suggestedAction.value = 'Schedule a vet visit if symptoms persist or worsen.';
    }

    currentStep.value = TriageStep.result;
  }

  void restartTriage() {
    selectedSpecies.value = '';
    selectedComplaint.value = '';
    currentQuestion.value = '';
    triageResult.value = '';
    suggestedAction.value = '';
    questionIndex.value = 0;
    questions.value = [];
    currentStep.value = TriageStep.species;
  }

  Color getResultColor() {
    if (triageResult.value.contains('Red')) return Colors.red;
    if (triageResult.value.contains('Yellow')) return Colors.amber;
    if (triageResult.value.contains('Green')) return Colors.green;
    return Colors.grey;
  }
}