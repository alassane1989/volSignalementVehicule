import 'package:flutter/material.dart';

class AdminStepsScreen extends StatefulWidget {
  const AdminStepsScreen({super.key});

  @override
  State<AdminStepsScreen> createState() => _AdminStepsScreenState();
}

class _AdminStepsScreenState extends State<AdminStepsScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2A3D),
        title: const Text("Perte de papiers et démarches"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A2A3D), Color(0xFF0F1E33)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader("📄 Perte de carte grise"),
            _stepsCard(_carteGriseSteps(), "Demande de duplicata (carte grise)"),

            const SizedBox(height: 16),
            _sectionHeader("🚗 Perte de permis de conduire"),
            _stepsCard(_permisSteps(), "Demande de duplicata (permis)"),

            const SizedBox(height: 16),
            _sectionHeader("🛡️ Perte d’attestation d’assurance"),
            _stepsCard(_assuranceSteps(), "Obtenir une nouvelle attestation"),

            const SizedBox(height: 16),
            _sectionHeader("ℹ️ Conseils généraux"),
            _tipsCard(),
          ],
        ),
      ),
    );
  }

  // Header stylisé
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Carte Stepper réutilisable
  Widget _stepsCard(List<_StepItem> steps, String label) {
    return Card(
      color: const Color(0xFF1A2A3D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.lightBlueAccent,
                ),
          ),
          child: Stepper(
            physics: const NeverScrollableScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (i) => setState(() => _currentStep = i),
            onStepContinue: () {
              if (_currentStep < steps.length - 1) {
                setState(() => _currentStep += 1);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            steps: steps
                .map(
                  (s) => Step(
                    title: Text(s.title,
                        style: const TextStyle(color: Colors.white)),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.desc,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 8),
                        if (s.actionLabel != null && s.route != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_forward,
                                  color: Colors.white),
                              label: Text(s.actionLabel!),
                              onPressed: () =>
                                  Navigator.pushNamed(context, s.route!),
                            ),
                          ),
                      ],
                    ),
                    isActive: true,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  // Carte de conseils généraux
  Widget _tipsCard() {
    return Card(
      color: const Color(0xFF1A2A3D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• Conservez des copies numériques de vos documents.",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 6),
            Text("• Déclarez la perte rapidement pour éviter les abus.",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 6),
            Text("• Mettez à jour vos signalements dans l’application.",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 6),
            Text("• Demandez un récépissé au commissariat.",
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // Données des étapes — Carte grise
  List<_StepItem> _carteGriseSteps() {
    return [
      _StepItem(
        title: "1. Déclarer la perte au commissariat",
        desc:
            "Rendez-vous au commissariat le plus proche et demandez un récépissé de déclaration de perte.",
        actionLabel: "Voir signalements publics",
        route: "/publicFeed",
      ),
      _StepItem(
        title: "2. Préparer les documents",
        desc:
            "Pièce d’identité, justificatif de domicile, récépissé de perte, informations du véhicule.",
      ),
      _StepItem(
        title: "3. Déposer la demande de duplicata",
        desc:
            "Déposez la demande auprès du service administratif compétent ou via le portail en ligne (si disponible).",
      ),
      _StepItem(
        title: "4. Suivre l’avancement",
        desc:
            "Conservez les numéros de dossier et suivez l’état de votre demande. Mettez à jour votre signalement si nécessaire.",
        actionLabel: "Mes signalements",
        route: "/myReports",
      ),
    ];
  }

  // Données des étapes — Permis
  List<_StepItem> _permisSteps() {
    return [
      _StepItem(
        title: "1. Déclaration de perte",
        desc:
            "Effectuez la déclaration officielle de perte et récupérez un récépissé.",
      ),
      _StepItem(
        title: "2. Dossier de duplicata",
        desc:
            "Préparez photo, pièce d’identité, justificatif de domicile, et le récépissé de perte.",
      ),
      _StepItem(
        title: "3. Dépôt du dossier",
        desc:
            "Déposez le dossier auprès du service compétent ou via le portail en ligne (si disponible).",
      ),
      _StepItem(
        title: "4. Récupération et vérification",
        desc:
            "Récupérez le duplicata et vérifiez l’exactitude des informations.",
      ),
    ];
  }

  // Données des étapes — Assurance
  List<_StepItem> _assuranceSteps() {
    return [
      _StepItem(
        title: "1. Contacter l’assureur",
        desc:
            "Informez votre compagnie d’assurance et demandez une nouvelle attestation.",
      ),
      _StepItem(
        title: "2. Fournir les informations",
        desc:
            "Identité, numéro de police, véhicule, et copie du récépissé de perte si demandé.",
      ),
      _StepItem(
        title: "3. Récupérer l’attestation",
        desc: "Recevez l’attestation et conservez une copie numérique.",
      ),
    ];
  }
}

// Modèle simple pour une étape
class _StepItem {
  final String title;
  final String desc;
  final String? actionLabel;
  final String? route;

  _StepItem({
    required this.title,
    required this.desc,
    this.actionLabel,
    this.route,
  });
}
