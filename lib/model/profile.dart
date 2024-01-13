class Profile {
  const Profile({this.id, required this.name, required this.image});

  final int? id;
  final String name;
  final String image;

  factory Profile.fromJSON(Map<String, dynamic> data) {
    return Profile(id: data['id'], image: data['image'], name: data["name"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "image": image,
      "name": name,
    };
  }
}
