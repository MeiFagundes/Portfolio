import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/utils/application_util.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/home/profile/profile.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_list_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ApplicationUtil.isMobileDevice(context)
          ? buildMobileLayout(context)
          : buildDesktopLayout(context),
    ));
  }

  Widget buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 550,
              child: Profile(),
            ),
            Divider(),
            ProjectListView(),
            buildSourceButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Flexible(
          flex: 5,
          child: SizedBox(
            height: 750,
            child: Column(
              children: [
                Spacer(),
                Expanded(
                  flex: 7,
                  child: Profile(),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => UrlUtil.openURI(UrlUtil.urlMetaProject),
                  child: Text(
                    'Site desenvolvido em Flutter for Web',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      letterSpacing: 0.7,
                    ),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Flexible(flex: 10, fit: FlexFit.loose, child: ProjectListView()),
      ],
    );
  }

  Widget buildSourceButton(BuildContext context) {
    return TextButton(
      onPressed: () => UrlUtil.openURI(UrlUtil.urlMetaProject),
      child: Text(
        'Site desenvolvido em Flutter for Web',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          letterSpacing: 0.7,
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
      ),
    );
  }
}
