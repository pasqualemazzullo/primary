class Pet {
  final int id;
  final String name;
  final String? breed;
  final String? imagePath;
  final Map<String, dynamic>? professionalDetails;
  final List<int>? professionals;
  final List<dynamic>? appointments;

  Pet({
    required this.id,
    required this.name,
    this.breed,
    this.imagePath,
    this.professionalDetails,
    this.professionals,
    this.appointments,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['petName'] ?? 'Senza nome',
      breed: json['petBreed'],
      imagePath: json['petImagePath'],
      professionalDetails: json['professionalDetails'],
      professionals:
          json['professionals'] != null
              ? List<int>.from(json['professionals'])
              : null,
      appointments: json['appointments'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'id': id, 'petName': name};

    if (breed != null) data['petBreed'] = breed;
    if (imagePath != null) data['petImagePath'] = imagePath;
    if (professionalDetails != null) {
      data['professionalDetails'] = professionalDetails;
    }
    if (professionals != null) data['professionals'] = professionals;
    if (appointments != null) data['appointments'] = appointments;

    return data;
  }
}
