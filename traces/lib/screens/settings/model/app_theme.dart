class AppTheme {
  final String name;
  final String path;  
  final String? iconsPath;
  const AppTheme({
    required this.name,
    required this.path,    
    this.iconsPath
  });
}

const List<AppTheme> AppThemes = [ 
  AppTheme(name: "plainOrange", path: "assets/plainOrangeTheme.jpg"),
  AppTheme(name: "brightBlue", path: "assets/brightBlueTheme.jpg", iconsPath: "assets/brightBlueTheme/"),
  AppTheme(name: "calmGreen", path: "assets/calmGreenTheme.jpg", iconsPath: "assets/calmGreenTheme/")
];