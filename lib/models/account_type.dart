class AccountType {
  String text;
  int value;
  String description;
  AccountType(
      {required this.text, required this.value, required this.description});

  // fromJson
  static AccountType fromJson(Map<String, dynamic> json) {
    return AccountType(
      text: json['text'],
      value: json['value'],
      description: json['description'],
    );
  }
}
