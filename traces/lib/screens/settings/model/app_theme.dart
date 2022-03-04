class AppTheme {
  final String name;
  final String path; 
  final String? author; 
  final String? iconsPath;
  const AppTheme({
    required this.name,
    required this.path,    
    this.author,
    this.iconsPath
  });
}

const List<AppTheme> AppThemes = [ 
  AppTheme(name: "plainOrange", path: "assets/plainOrangeTheme.jpg"),
  AppTheme(name: "brightBlue", path: "assets/brightBlueTheme.jpg", iconsPath: "assets/brightBlueTheme/", author: "monkik"),
  AppTheme(name: "calmGreen", path: "assets/calmGreenTheme.jpg", iconsPath: "assets/calmGreenTheme/", author: "Freepik")
];