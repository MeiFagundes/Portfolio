import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/models/project_model.dart';

class ProjectsRepository {
  static List<ProjectModel> getProjects() {
    return [
      ProjectModel(
        title: 'Starlight',
        description:
            'Biblioteca de Natural Language Processing (NLP) from scratch que incorpora Machine Learning através da framework ML.NET. O projeto já possui o seu próprio dataset, totalmente aberto e customizável, para treinamento da IA.',
        imagePath: 'assets/images/Starlight.jpg',
        links: [
          ProjectLink(
              icon: Icons.download_rounded,
              description: 'Download',
              uri:
                  'https://github.com/MeiFagundes/Starlight/archive/master.zip'),
          ProjectLink(
              icon: Icons.code,
              description: 'Código fonte',
              uri: 'https://github.com/MeiFagundes/Starlight'),
        ],
      ),
      ProjectModel(
        title: 'PolarisAI',
        description:
            'Biblioteca/RESTful API de processamento de requisições e Assistente Pessoal. Foi desenvolvida usando as funções cognitivas do projeto Starlight. A API pode ser testada através do cliente web disponível no link abaixo.',
        imagePath: 'assets/images/PolarisAI.png',
        links: [
          ProjectLink(
              icon: Icons.launch,
              description: 'Testar API',
              uri: 'https://meifagundes.com/PolarisAI-Web/'),
          ProjectLink(
              icon: Icons.download_rounded,
              description: 'Download',
              uri:
                  'https://github.com/MeiFagundes/PolarisAI/archive/master.zip'),
          ProjectLink(
              icon: Icons.code,
              description: 'Código fonte',
              uri: 'https://github.com/MeiFagundes/PolarisAI'),
        ],
      ),
      ProjectModel(
        title: 'MyQuimicaLab',
        description:
            'Projeto de Iniciação Científica em colaboração com o CEFET-MG. Tem como objetivo ensinar química orgânica através da experiência lúdica e descontraída de um jogo. Desenvolvido em JavaScript através da Game Engine Phaser.',
        imagePath: 'assets/images/MyQuimicaLab.jpg',
        links: [
          ProjectLink(
              icon: Icons.download_rounded,
              description: 'Download',
              uri:
                  'https://github.com/MyQuimicaLab/MyQuimicaLab.github.io/archive/master.zip'),
          ProjectLink(
              icon: Icons.code,
              description: 'Código fonte',
              uri: 'https://github.com/MyQuimicaLab/MyQuimicaLab.github.io'),
        ],
      ),
      ProjectModel(
        title: 'ListDeclutteringTool',
        description:
            'Aplicação para limpar, formatar e organizar listas de conteúdo. Facilita principalmente a formatação de dados obtidos da web para usos diversos. Construído em WPF para Windows.',
        imagePath: 'assets/images/ListDeclutteringTool.jpg',
        links: [
          ProjectLink(
              icon: Icons.download_rounded,
              description: 'Download',
              uri:
                  'https://github.com/MeiFagundes/ListDeclutteringTool/releases'),
          ProjectLink(
              icon: Icons.code,
              description: 'Código fonte',
              uri: 'https://github.com/MeiFagundes/ListDeclutteringTool'),
        ],
      ),
      ProjectModel(
        title: 'Sqrt8086',
        description:
            'Algoritmo escrito em Assembly 8086 que calcula a raiz quadrada de um número com precisão decimal na arquitetura Intel 8086, mesmo com esta não suportando Floating Point e sendo limitada a 16Bits.',
        imagePath: 'assets/images/Sqrt8086.jpg',
        links: [
          ProjectLink(
              icon: Icons.download_rounded,
              description: 'Download',
              uri: 'https://github.com/MeiFagundes/Sqrt8086/releases'),
          ProjectLink(
              icon: Icons.code,
              description: 'Código fonte',
              uri: 'https://github.com/MeiFagundes/Sqrt8086'),
        ],
      ),
      ProjectModel(
        title: 'DexDB',
        description:
            'Proof of concept de uma PokeDex Web com cliente, Servlet e DataBase. Foi escrita em JavaScript, Java e MySQL. Seu design foi inspirado no Material Design da Google.',
        imagePath: 'assets/images/DexDB.jpg',
        links: [
          ProjectLink(
              icon: Icons.download_rounded,
              description: 'Download',
              uri: 'https://github.com/MeiFagundes/DexDB/archive/master.zip'),
          ProjectLink(
              icon: Icons.code,
              description: 'Código fonte',
              uri: 'https://github.com/MeiFagundes/DexDB'),
        ],
      ),
    ];
  }
}
