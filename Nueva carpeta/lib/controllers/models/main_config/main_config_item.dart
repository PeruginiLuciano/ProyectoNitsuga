class MainConfigItem {
  String type;
  String name;
  String value;

  MainConfigItem({
    required this.type, 
    required this.name, 
    required this.value
  });

  factory MainConfigItem.fromJson(Map<String, dynamic> json) {
    return MainConfigItem(
      type: json['type'] as String,
      name: json['name'] as String,
      value: json['value'] as String
    );
  }

  Map<String, dynamic> toJson() => {
    'type' : type,
    'name' : name,
    'value' : value
  };
}
