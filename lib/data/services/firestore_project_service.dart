import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meifagundesdotcom/data/services/project_service.dart';

class FirestoreProjectService implements ProjectService {
  final FirebaseFirestore _firestore;

  FirestoreProjectService({required this._firestore});

  @override
  Future<List<Map<String, dynamic>>> loadProjects() async {
    final snapshot = await _firestore
        .collection('portfolio')
        .doc('projects')
        .collection('project list')
        .orderBy('priority')
        .get();

    return List.unmodifiable(snapshot.docs.map((doc) => doc.data()));
  }
}
