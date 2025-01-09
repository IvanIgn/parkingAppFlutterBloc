import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  @Id()
  int id; // Default to 0, the expected value for unassigned IDs in ObjectBox
  String name;
  String personNumber;

  Person({
    required this.name,
    required this.personNumber,
    this.id = 0, // Default to 0 for unassigned ID
  });

  // Factory constructor to create a Person from JSON
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? 0, // Default to 0 if ID is missing
      name: json['name'] ?? '',
      personNumber: json['personNumber'] ?? '',
    );
  }

  // Convert a Person object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "personNumber": personNumber,
    };
  }
}
