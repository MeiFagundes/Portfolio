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
          backgroundColor: Colors.transparent,
          maxRadius: 85,
        ),
        Spacer(),
        Text(
          'Mei Fagundes',
          style: TextStyles.profileName,
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
              'Formada no CEFET-MG e atualmente estagiando na DTI Digital. Gosto de fazer uns projetos bem aleatórios para testar várias tecnologias legais. Caso te interesse, me segue lá no GitHub ou me mande uma estrelinha através de um dos projetos ao lado.',
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
              icon: Icon(Icons.email, color: Colors.pinkAccent),
              label: Text('E-mail', style: TextStyles.profileButton),
              padding: EdgeInsets.all(13),
            ),
            FlatButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlGithub),
              icon: Icon(CustomIcons.github, color: Colors.pinkAccent),
              label: Text('GitHub', style: TextStyles.profileButton),
              padding: EdgeInsets.all(13),
            ),
            FlatButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlLinkedin),
              icon: Icon(CustomIcons.linkedin, color: Colors.pinkAccent),
              label: Text('LinkedIn', style: TextStyles.profileButton),
              padding: EdgeInsets.all(13),
            ),
          ],
        ),
      ],
    );
  }
}
