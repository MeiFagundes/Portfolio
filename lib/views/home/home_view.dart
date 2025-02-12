import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/home/profile/profile.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_list_view.dart';
import 'package:meifagundesdotcom/views/shared/padding_sizes.dart';

class Home extends StatelessWidget {
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _projectListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth >= 1160 ? desktopLayout : mobileLayout;
      }),
    ));
  }

  Widget get mobileLayout {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Profile(),
                  Divider(),
                  projectList,
                  sourceButton,
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
        constraints: BoxConstraints(maxWidth: 1500),
        child: Row(
          children: [
            SizedBox(width: PaddingSizes.homePadding),
            Expanded(
              flex: 5,
              child: Container(
                constraints: BoxConstraints(maxHeight: 620),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Profile(),
                    sourceButton,
                  ],
                ),
              ),
            ),
            SizedBox(width: PaddingSizes.homePadding),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: projectList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get sourceButton {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextButton(
        onPressed: () => UrlUtil.openURI(UrlUtil.urlMetaProject),
        child: Row(
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
        ),
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
        ),
      ),
    );
  }

  Widget get profile => ProjectListView(key: _profileKey);

  Widget get projectList => ProjectListView(key: _projectListKey);
}
