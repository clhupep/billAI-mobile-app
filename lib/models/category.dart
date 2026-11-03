class Category {
  const Category(this.name);
  final String name;
  factory Category.fromJson(Map<String, dynamic> json) => Category(json['name'] as String);
}
