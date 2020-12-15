import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/views/home/profile.dart';
import 'package:meifagundesdotcom/views/home/project_list_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Mei Fagundes'),
      //   centerTitle: true,
      // ),
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
                  Flexible(
                    flex: 7,
                    child: Profile(),
                  ),
                  Spacer(),
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
