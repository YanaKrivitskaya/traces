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
  AppTheme(name: "plainOrange", path: "assets/plainOrangeTheme.png"),
  AppTheme(name: "brightBlue", path: "assets/brightBlueTheme.png", iconsPath: "assets/brightBlueTheme/", author: "monkik"),
  AppTheme(name: "calmGreen", path: "assets/calmGreenTheme.png", iconsPath: "assets/calmGreenTheme/", author: "Freepik"),
  AppTheme(name: "strictGreen", path: "assets/strictGreenTheme.png", iconsPath: "assets/strictGreenTheme/", author: "pikslgrafik")
];