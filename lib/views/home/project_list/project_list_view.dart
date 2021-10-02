import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_card.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';
import 'package:meifagundesdotcom/utils/application_util.dart';

class ProjectListView extends StatefulWidget {
  @override
  State<ProjectListView> createState() => _ProjectListViewState();
}

class _ProjectListViewState extends State<ProjectListView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var firestoreFuture;

  @override
  void initState() {
    firestoreFuture = firestore
        .collection('portfolio')
        .doc('projects')
        .collection('project list')
        .orderBy('priority')
        .snapshots()
        .first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationUtil.isMobileDevice(context)
        ? buildMobileLayout(context)
        : buildDesktopLayout(context);
  }

  Widget buildMobileLayout(BuildContext context) {
    return buildBaseLayout(context);
  }

  Widget buildDesktopLayout(BuildContext context) {
    return buildBaseLayout(context);
  }

  Widget buildBaseLayout(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firestoreFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            final projetos = snapshot.data!.docs
                .map(
                  (doc) => ProjectModel.fromFirestoreDoc(doc),
                )
                .toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Projetos Pessoais',
                      style: TextStyles.title,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (final project in projetos) ProjectCard(project),
                    ],
                  ),
                ],
              ),
            );
          } else
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
        });
  }
}
