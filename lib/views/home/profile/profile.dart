import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';
import 'package:meifagundesdotcom/views/shared/custom_icons.dart';
import 'package:meifagundesdotcom/views/shared/text_styles.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: 10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(
            'assets/images/mei.jpg',
          ),
          backgroundColor: Colors.transparent,
          maxRadius: 100,
        ),
        spacer,
        Text(
          'Mei Fagundes',
          style: TextStyles.profileName,
        ),
        spacer,
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
        spacer,
        Center(
          child: Text(
            'Formada no CEFET-MG e Consultora de Software na Thoughtworks. Gosto de fazer uns projetinhos bem aleatórios para testar várias tecnologias legais. Caso te interesse, me segue lá no GitHub ou me mande uma estrelinha através de um dos projetos listados.',
            style: TextStyles.profileDescription,
            textAlign: TextAlign.center,
          ),
        ),
        spacer,
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
        spacer,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlEmail),
              icon: Icon(
                Icons.email,
                color: Colors.pinkAccent,
              ),
              label: Text('E-mail'),
            ),
            TextButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlGithub),
              icon: Icon(
                CustomIcons.github,
                color: Colors.pinkAccent,
              ),
              label: Text('GitHub'),
            ),
            TextButton.icon(
              onPressed: () => UrlUtil.openURI(UrlUtil.urlLinkedin),
              icon: Icon(
                CustomIcons.linkedin,
                color: Colors.pinkAccent,
              ),
              label: Text('LinkedIn'),
            ),
          ],
        ),
        spacer,
      ],
    );
  }
}
