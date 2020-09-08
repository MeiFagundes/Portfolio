class ProjectModel {
  static final List<ProjectModel> projects = [
    ProjectModel(
      title: 'Starlight',
      description:
          'Engine de Natural Language Processing (NLP) que incorpora Machine Learning através da framework ML.NET. O projeto já possui o seu próprio dataset, totalmente aberto e customizável, para treinamento da IA.',
      imagePath: 'assets/images/Starlight.jpg',
      downloadURI: 'https://github.com/MeiFagundes/Starlight/releases',
      sourceCodeURI: 'https://github.com/MeiFagundes/Starlight',
    ),
    ProjectModel(
      title: 'PolarisAI',
      description:
          'Biblioteca/RESTful API de processamento de requisições e Assistente Pessoal, foi construida usando as funções cognitivas do projeto Starlight. Um cliente Web está disponível para que qualquer um possa testar a API.',
      imagePath: 'assets/images/PolarisAI.jpg',
      launchURI: 'https://meifagundes.com/PolarisAI-Web/',
      sourceCodeURI: 'https://github.com/MeiFagundes/PolarisAI',
    ),
    ProjectModel(
      title: 'ListDeclutteringTool',
      description:
          'Programa que ajuda a limpar, formatar e organizar listas de conteúdo, facilita principalmente a formatação de dados obtidos da web para usos diversos. Construído em WPF para Windows.',
      imagePath: 'assets/images/ListDeclutteringTool.jpg',
      downloadURI:
          'https://github.com/MeiFagundes/ListDeclutteringTool/releases',
      sourceCodeURI: 'https://github.com/MeiFagundes/ListDeclutteringTool',
    ),
    ProjectModel(
      title: 'DexDB',
      description:
          'Proof of concept de uma PokeDex Web com cliente, server e dataBase (usando Servlets). Foi escrito em JavaScript, Java e MySQL. Seu design foi inspirado no Material Design da Google.',
      imagePath: 'assets/images/DexDB.jpg',
      downloadURI: 'https://github.com/MeiFagundes/DexDB/archive/master.zip',
      sourceCodeURI: 'https://github.com/MeiFagundes/DexDB',
    ),
    ProjectModel(
      title: 'Sqrt8086',
      description:
          'Algoritmo escrito em Assembly 8086 que calcula a raiz quadrada de um número com precisão decimal na arquitetura Intel 8086, mesmo que esta não possua suporte para Floating Point e seja limitada a 16Bits.',
      imagePath: 'assets/images/Sqrt8086.jpg',
      downloadURI: 'https://github.com/MeiFagundes/Sqrt8086/releases',
      sourceCodeURI: 'https://github.com/MeiFagundes/Sqrt8086',
    ),
    ProjectModel(
      title: 'BioPrantinhas',
      description:
          'Site voltado para o ensino de Botânica. Disponibiliza explicações, imagens e vídeos sobre Briófitas, Pteridófitas, Gimnospermas e Angiospermas.',
      imagePath: 'assets/images/BioPrantinhas.jpg',
      launchURI: 'https://bioprantinhas.github.io/',
      sourceCodeURI: 'https://github.com/BioPrantinhas/bioprantinhas.github.io',
    ),
  ];

  String title;
  String description;
  String imagePath;
  String launchURI;
  String downloadURI;
  String sourceCodeURI;

  ProjectModel(
      {this.title,
      this.description,
      this.imagePath,
      this.launchURI,
      this.downloadURI,
      this.sourceCodeURI});
}
