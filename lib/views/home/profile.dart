import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/shared/custom_icons.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/mei.jpg'),
          maxRadius: 70,
        ),
        Spacer(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Divider(),
            ),
            Spacer()
          ],
        ),
        Expanded(
          flex: 10,
          child: Center(
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
              style: TextStyles.profileDescription,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Divider(),
            ),
            Spacer()
          ],
        ),
        Spacer(),
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlEmail),
              icon: Icon(Icons.email),
              label: Text('E-mail'),
              padding: EdgeInsets.all(13),
            ),
            FlatButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlGithub),
              icon: Icon(CustomIcons.github),
              label: Text('GitHub'),
              padding: EdgeInsets.all(13),
            ),
            FlatButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlLinkedin),
              icon: Icon(CustomIcons.linkedin),
              label: Text('LinkedIn'),
              padding: EdgeInsets.all(13),
            ),
          ],
        ),
      ],
    );
  }
}
