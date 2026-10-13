import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/data/project_repository.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/views/home/profile/profile.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_list_view.dart';
import 'package:meifagundesdotcom/views/shared/padding_sizes.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.loadProjects});
  final Future<List<ProjectModel>> Function()? loadProjects;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ProjectModel>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = _fetchProjects();
  }

  Future<List<ProjectModel>> _fetchProjects() async =>
      (widget.loadProjects ?? ProjectRepository().loadProjects)();

  Future<List<ProjectModel>> _loadProjects() => _projects;

  Future<List<ProjectModel>> _retryProjects() {
    _projects = _fetchProjects();
    return _projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth >= 1160 &&
                    constraints.maxHeight >= 700 &&
                    MediaQuery.textScalerOf(context).scale(1) <= 1.2
                ? desktopLayout
                : mobileLayout;
          },
        ),
      ),
    );
  }

  Widget get mobileLayout {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Profile(),
                  const Divider(),
                  projectList,
                  sourceButton,
                  versionNumber,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get desktopLayout {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1500),
        child: Row(
          children: [
            SizedBox(width: PaddingSizes.homePadding),
            Expanded(
              flex: 5,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 700),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [const Profile(), sourceButton, versionNumber],
                  ),
                ),
              ),
            ),
            SizedBox(width: PaddingSizes.homePadding),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(child: projectList),
            ),
          ],
        ),
      ),
    );
  }

  Widget get sourceButton {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Built with ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            letterSpacing: 0.7,
          ),
        ),
        FlutterLogo(size: 58, style: FlutterLogoStyle.horizontal),
      ],
    );
  }

  Widget get versionNumber {
    return const Text(
      'v1.7.0',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget get projectList => ProjectListView(
    loadProjects: _loadProjects,
    retryProjects: _retryProjects,
  );
}
