class ProjectModel {
  static final List<ProjectModel> projects = [
    ProjectModel(
      title: 'Starlight',
      description:
          'Uma Engine de Natural Language Processing (NLP) que incorpora Machine Learning através da framework ML.NET. O processamento é feito através de Datasets para treinamento da IA.',
      imagePath: 'assets/images/Starlight.jpg',
      downloadURI: 'https://github.com/MeiFagundes/Starlight/releases',
      sourceCodeURI: 'https://github.com/MeiFagundes/Starlight',
    ),
    ProjectModel(
      title: 'PolarisAI',
      description:
          'Uma Engine/RESTful API de processamento de requisições e Assistente Pessoal construida usando as funções cognitivas do projeto Starlight. Um cliente para Browsers está atualmente disponível.',
      imagePath: 'assets/images/PolarisAI.jpg',
      launchURI: 'https://meifagundes.com/PolarisAI-Web/',
      sourceCodeURI: 'https://github.com/MeiFagundes/PolarisAI',
    ),
    ProjectModel(
      title: 'ListDeclutteringTool',
      description:
          'ListDeclutteringTool é um programa para ajudar a limpar, formatar e organizar grandes listas de conteúdo, ele facilita principalmente a formatação dados copiados de sites para usos diversos. Foi feito para Windows e escrito em C# usando a .NET FrameWork 4.6.1.',
      imagePath: 'assets/images/ListDeclutteringTool.jpg',
      downloadURI:
          'https://github.com/MeiFagundes/ListDeclutteringTool/releases',
      sourceCodeURI: 'https://github.com/MeiFagundes/ListDeclutteringTool',
    ),
    ProjectModel(
      title: 'Starlight',
      description:
          'Uma Engine de Natural Language Processing (NLP) que incorpora Machine Learning através da framework ML.NET. O processamento é feito através de Datasets para treinamento da IA.',
      imagePath: 'assets/images/Starlight.jpg',
      downloadURI: 'https://github.com/MeiFagundes/Starlight/releases',
      sourceCodeURI: 'https://github.com/MeiFagundes/Starlight',
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
