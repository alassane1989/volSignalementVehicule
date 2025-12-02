import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationHistoryScreen extends StatefulWidget {
  @override
  _VerificationHistoryScreenState createState() => _VerificationHistoryScreenState();
}

class _VerificationHistoryScreenState extends State<VerificationHistoryScreen> {
  String filterPlate = "";
  DateTime? filterDate;

  Stream<QuerySnapshot> getVerifications() {
    final ref = FirebaseFirestore.instance.collection('verifications');

    Query query = ref.orderBy('date', descending: true);

    if (filterPlate.isNotEmpty) {
      query = query.where('plaque', isEqualTo: filterPlate);
    }

    if (filterDate != null) {
      final start = DateTime(filterDate!.year, filterDate!.month, filterDate!.day);
      final end = start.add(Duration(days: 1));
      query = query.where('date', isGreaterThanOrEqualTo: start).where('date', isLessThan: end);
    }

    return query.snapshots();
  }

  void markAsTraite(String docId) {
    FirebaseFirestore.instance.collection('verifications').doc(docId).update({
      'traite': true,
    });
  }

  void notifyCitizen(String citizenId) async {
    // Simule l’envoi de notification
    print("Notification envoyée à $citizenId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1E33),
      appBar: AppBar(title: Text("Historique des vérifications")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => filterPlate = val.trim()),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Filtrer par plaque",
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => filterDate = picked);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getVerifications(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(child: Text("Aucun contrôle trouvé", style: TextStyle(color: Colors.white)));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final docId = docs[index].id;

                    return Card(
                      color: Colors.blueGrey[900],
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text("Plaque : ${data['plaque']}", style: TextStyle(color: Colors.white)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Résultat : ${data['resultat']}", style: TextStyle(color: Colors.white70)),
                            Text("Date : ${data['date'].toDate()}", style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            if (data['traite'] == false)
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.greenAccent),
                                onPressed: () => markAsTraite(docId),
                              ),
                            IconButton(
                              icon: Icon(Icons.notifications, color: Colors.orangeAccent),
                              onPressed: () => notifyCitizen(data['citizenId']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
