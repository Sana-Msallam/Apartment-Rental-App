class UserModel {
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

  factory UserModel.fromJson(Map<String, dynamic> json, {required token}) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['date_of_birth'],
      personalPhoto: json['personal_photo'],
      idPhoto: json['ID_photo'],
      token: json['token'], // تأكدي أن  التوكن داخل مصفوفة اليوزر أو مرريه يدوياً
    );
  }

  // إذا احتجتِ تحويل الكائن إلى Map لإرساله للسيرفر (اختياري)
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