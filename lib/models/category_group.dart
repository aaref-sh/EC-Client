class CategoryGroup {
  int id;
  String name;

  CategoryGroup({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  static CategoryGroup fromJson(Map<String, dynamic> json) => CategoryGroup(
        id: json['id'],
        name: json['name'],
      );
}
