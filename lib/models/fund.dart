class Fund {
  int id;
  String name;
  String phone;
  String type;
  String classification; // Renamed from 'class' to avoid keyword conflict
  String address;
  String taxesNumber;

  Fund({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.classification,
    required this.address,
    required this.taxesNumber,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'type': type,
        'classification': classification,
        'address': address,
        'taxesNumber': taxesNumber,
      };

  static Fund fromJson(Map<String, dynamic> json) => Fund(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        type: json['type'],
        classification: json['classification'],
        address: json['address'],
        taxesNumber: json['taxesNumber'],
      );
}
