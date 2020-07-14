class Categories{
  final String name;
  final int numofCourses;
  final String image;
  final String route;
  Categories(this.name, this.numofCourses, this.image, this.route);
}

List<Categories> categories = categoriesData
  .map((item) => Categories(item['name'], item['courses'], item['image'], item['Route'] ))
    .toList();

var categoriesData = [
  {'name': 'HULM', 'courses': 17, 'image': 'assets/images/marketing.png', 'Route': '/Marketing'},
  {'name': 'Open Elec.', 'courses': 12, 'image': 'assets/images/ux_design.png', 'Route': '/DesignThinking'},
  {'name': 'Dept. Elec', 'courses': 15, 'image': 'assets/images/photography.png', "Route": '/Photography'},
  {'name': 'Bussiness', 'courses': 8, 'image': 'assets/images/business.png', "Route": '/Bussiness'},
];


