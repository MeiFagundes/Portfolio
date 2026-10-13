import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meifagundesdotcom/models/project_model.dart';

class ProjectRepository {
  ProjectRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<ProjectModel>> loadProjects() async {
    final snapshot = await _firestore
        .collection('portfolio')
        .doc('projects')
        .collection('project list')
        .orderBy('priority')
        .get();

    return List.unmodifiable(
      snapshot.docs.map((doc) => ProjectModel.fromMap(doc.data())).toList(),
    );
  }
}
