import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../models/Report.dart';
import '../../services/report_service.dart';
import '../../services/likes_service.dart';
import '../../services/comments_service.dart';
import '../../services/abuse_flags_service.dart';
import 'report_detail_screen.dart';

class PublicFeedScreen extends StatelessWidget {
  final _reportService = ReportService();
  final _likesService = LikesService();
  final _commentsService = CommentsService();
  final _abuseService = AbuseFlagsService();

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;
    final userRole = user != null ? "citizen" : "guest";
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Signalements publics")),
      body: StreamBuilder<List<Report>>(
        stream: _reportService.getPublicReportsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Erreur de chargement"));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final reports = snapshot.data!;
          if (reports.isEmpty) return Center(child: Text("Aucun signalement public disponible"));

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (_, i) {
              final r = reports[i];
              final photoUrl = r.photos.isNotEmpty ? r.photos.first : r.photo;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 12 : 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ En-tête du signalement
                    ListTile(
                      leading: photoUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                photoUrl,
                                width: screenWidth < 600 ? 55 : 80,
                                height: screenWidth < 600 ? 55 : 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              child: Icon(Icons.report, color: Colors.white),
                            ),
                      title: Text(
                        r.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: screenWidth < 600 ? 16 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Description complète et responsive
                          Text(
                            r.description,
                            style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            r.isValidated
                                ? "✅ Validé par la police"
                                : "⏳ En attente de validation",
                            style: TextStyle(
                              color: r.isValidated ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth < 600 ? 12 : 14,
                            ),
                          ),
                          Text(
                            "Statut : ${r.statut}",
                            style: TextStyle(fontSize: screenWidth < 600 ? 12 : 14),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        if (userRole == "guest") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Connectez-vous pour voir les détails")),
                          );
                          Navigator.pushNamed(context, '/login');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportDetailScreen(reportId: r.id),
                            ),
                          );
                        }
                      },
                    ),

                    Divider(),

                    // ✅ Barre d’actions sociales responsive
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          // ✅ Like
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.thumb_up_alt_outlined),
                              iconSize: screenWidth < 600 ? 24 : 30,
                              onPressed: () {
                                if (userRole == "guest") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Connectez-vous pour aimer un signalement")),
                                  );
                                  Navigator.pushNamed(context, '/login');
                                } else {
                                  _likesService.likeReport(r.id, user!.uid);
                                }
                              },
                              tooltip: "J’aime",
                            ),
                          ),

                          // ✅ Commenter
                         Expanded(
  child: Column(
    children: [
      IconButton(
        icon: Icon(Icons.comment_outlined),
        iconSize: screenWidth < 600 ? 24 : 30,
        onPressed: () {
          if (userRole == "guest") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Connectez-vous pour commenter")),
            );
            Navigator.pushNamed(context, '/login');
          } else {
            _openComments(context, r.id);
          }
        },
        tooltip: "Commenter",
      ),
      Text("${r.commentsCount ?? 0}", style: TextStyle(fontSize: 12)),
    ],
  ),
),


                          // ✅ Partager
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.share_outlined),
                              iconSize: screenWidth < 600 ? 24 : 30,
                              onPressed: () => _shareReport(context, r),
                              tooltip: "Partager",
                            ),
                          ),

                          // ✅ Signaler abus
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.flag_outlined, color: Colors.red),
                              iconSize: screenWidth < 600 ? 24 : 30,
                              onPressed: () {
                                if (userRole == "guest") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Connectez-vous pour signaler un abus")),
                                  );
                                  Navigator.pushNamed(context, '/login');
                                } else {
                                  _abuseService.flagReport(r.id, user!.uid, "abus");
                                }
                              },
                              tooltip: "Signaler abus",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ✅ Ouvrir écran commentaires
  void _openComments(BuildContext context, String reportId) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StreamBuilder<List<Map<String, dynamic>>>(
        stream: _commentsService.commentsStream(reportId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final comments = snapshot.data!;
          return ListView(
            children: comments
                .map((c) => ListTile(
                      title: Text(c['text']),
                      subtitle: Text("Par ${c['userId']}"),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  // ✅ Partage natif
  void _shareReport(BuildContext context, Report r) {
    final text = "Signalement ${r.type}: ${r.description}";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Fonction de partage à intégrer")),
    );
  }
}
