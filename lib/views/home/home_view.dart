import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/home/profile/profile.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_list_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Spacer(),
          Flexible(
            flex: 5,
            child: Container(
              constraints: BoxConstraints(maxHeight: 650),
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
                      'Site desenvolvido em Flutter Web',
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
          Expanded(flex: 10, child: ProjectListView()),
          Spacer(),
        ],
      ),
    );
  }
}
