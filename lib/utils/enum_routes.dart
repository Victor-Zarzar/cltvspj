enum AppRoute {
  home('/', 'home'),
  clt('/clt', 'clt'),
  pj('/pj', 'pj'),
  user('/user', 'user'),
  settings('/settings', 'settings');

  const AppRoute(this.path, this.name);
  final String path;
  final String name;
}
