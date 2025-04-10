class Location {
  final String name;
  final String address;

  const Location({required this.name, required this.address});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(name: json['name'], address: json['address']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address};
  }
}
