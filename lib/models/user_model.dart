class UserModel {
  static UserModel? currentUser; 
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? personalPhoto; 
  final String? idPhoto;
  final String? token;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.personalPhoto,
    this.idPhoto,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    String? rawPhoto = json['personal_photo'];
    String? processedPhoto;

    if (rawPhoto != null && rawPhoto.isNotEmpty) {
      if (rawPhoto.startsWith('http')) {
        processedPhoto = rawPhoto; 
      } else {
        processedPhoto = "http://192.168.1.102:8000/storage/$rawPhoto";
      }
    }

    return UserModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '', 
      dateOfBirth: json['date_of_birth'],
      personalPhoto: processedPhoto,
      idPhoto: json['ID_photo'],
      token: token ?? json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'personal_photo': personalPhoto,
      'ID_photo': idPhoto,
      'token': token,
    };
  }
}