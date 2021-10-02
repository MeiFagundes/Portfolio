import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProjectModel {
  String title;
  String description;
  String imagePath;
  List<ProjectLink> links;

  ProjectModel(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.links});

  static ProjectModel fromFirestoreDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    var links = <ProjectLink>[];
    doc.data()['links'].toList().forEach(
          (link) => links.add(
            ProjectLink.fromType(type: link['type'], uri: link['url']),
          ),
        );

    return ProjectModel(
      title: doc.data()['title'],
      description: doc.data()['description'],
      imagePath: doc.data()['imageUrl'],
      links: links,
    );
  }
}

class ProjectLink {
  IconData icon;
  String description;
  String uri;

  ProjectLink(
      {required this.icon, required this.description, required this.uri});

  ProjectLink.fromType({required String type, required String uri})
      : this.icon = _getIconByType(type),
        this.description = _getDescriptionByType(type),
        this.uri = uri;

  static String _getDescriptionByType(String type) {
    switch (type) {
      case 'launch':
        return "Acessar";
      case 'download':
        return "Download";
      case 'source':
        return "Código Fonte";
      default:
        return "";
    }
  }

  static IconData _getIconByType(String type) {
    switch (type) {
      case 'launch':
        return Icons.launch;
      case 'download':
        return Icons.download;
      case 'source':
        return Icons.code;
      default:
        return Icons.circle;
    }
  }
}
