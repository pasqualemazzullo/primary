class Professional {
  final int id;
  final String name;
  final String specialty;
  final String? imagePath;
  final String? contactInfo;
  final String? email;
  final Map<String, dynamic>? location;

  const Professional({
    required this.id,
    required this.name,
    required this.specialty,
    this.imagePath,
    this.contactInfo,
    this.email,
    this.location,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'],
      name: json['name'] ?? 'Nome non disponibile',
      specialty: json['specialty'] ?? 'Specialità non specificata',
      imagePath: json['imagePath'],
      contactInfo: json['contactInfo'],
      email: json['email'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'imagePath': imagePath,
      'contactInfo': contactInfo,
      'email': email,
      'location': location,
    };
  }
}
