class UserFileds {
  static final String id = 'id';
  static final String name = 'name';
  static String email = 'email';
  static String phone = 'phone';
  static String image = 'image';

  static List<String> getFields() => [id, name, email, phone, image];
}
class user {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? image;

  const user({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  Map<String, dynamic> toJson() => {
    UserFileds.id: id,
    UserFileds.name: name,
    UserFileds.email: email,
    UserFileds.phone: phone,
    UserFileds.image: image,
  };
}