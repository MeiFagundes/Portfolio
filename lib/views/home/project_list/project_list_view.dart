import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_card.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';

class ProjectListView extends StatefulWidget {
  const ProjectListView({
    super.key,
    required this.loadProjects,
    this.retryProjects,
  });

  final Future<List<ProjectModel>> Function() loadProjects;
  final Future<List<ProjectModel>> Function()? retryProjects;

  @override
  State<ProjectListView> createState() => _ProjectListViewState();
}

class _ProjectListViewState extends State<ProjectListView> {
  late Future<List<ProjectModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _loadProjects();
  }

  @override
  void didUpdateWidget(covariant ProjectListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadProjects != widget.loadProjects ||
        oldWidget.retryProjects != widget.retryProjects) {
      _projectsFuture = _loadProjects();
    }
  }

  Future<List<ProjectModel>> _loadProjects([
    Future<List<ProjectModel>> Function()? loader,
  ]) {
    try {
      final future = (loader ?? widget.loadProjects)();
      future.ignore();
      return future;
    } catch (error, stackTrace) {
      final future = Future<List<ProjectModel>>.error(error, stackTrace);
      future.ignore();
      return future;
    }
  }

  void _retry() {
    setState(() {
      _projectsFuture = _loadProjects(
        widget.retryProjects ?? widget.loadProjects,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProjectModel>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _section(
            const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _section(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Não foi possível carregar os projetos.'),
                TextButton(
                  onPressed: _retry,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        final projects = snapshot.data ?? const <ProjectModel>[];
        if (projects.isEmpty) {
          return _section(const Text('Nenhum projeto disponível no momento.'));
        }

        return _section(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [for (final project in projects) ProjectCard(project)],
          ),
        );
      },
    );
  }

  Widget _section(Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Projetos Pessoais', style: TextStyles.title),
          ),
          content,
        ],
      ),
    );
  }
}
