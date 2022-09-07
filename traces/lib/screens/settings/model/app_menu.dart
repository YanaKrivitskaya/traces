class AppMenu {
  final String name;
  final String path;   
  const AppMenu({
    required this.name,
    required this.path
  });
}

const List<AppMenu> AppMenues = [ 
  AppMenu(name: "dashboard", path: "assets/menu_dashboard.png"),
  AppMenu(name: "drawer", path: "assets/menu_drawer.png")
];