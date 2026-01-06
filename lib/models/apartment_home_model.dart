class Apartment {
  final int id;
  final int price;
  final String governorate;
  final String city;
  final int space;
  final int? averageRating;
  final String imagePath;
  final bool is_favorite;

  Apartment({
    required this.id,
    required this.price,
    required this.governorate,
    required this.city,
    required this.space,
    required this.imagePath,
    this.averageRating,
    this.is_favorite = false,
  });
  Apartment copyWith({
    int? id,
    int? price,
    int? space,
    String? governorate,
    String? city,
    String? imagePath,
    int? averageRating, 
    bool? is_favorite,
  }) {
    return Apartment(
      id: id ?? this.id,
      price: price ?? this.price,
      space: space ?? this.space,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      imagePath: imagePath ?? this.imagePath,
      averageRating: averageRating ?? this.averageRating,
      is_favorite: is_favorite ?? this.is_favorite,
    );
  }

  factory Apartment.fromJson(Map<String, dynamic> json) {
    String rawPath = json['main_image'] != null ? json['main_image']['path'] : '';
    
    // ملاحظة: تأكدي من توحيد الـ IP (كنتِ تستخدمين 10.0.2.2 والآن 192.168.1.105)
    String baseUrl = "http://10.0.2.2:8000"; 
    String correctedPath = rawPath.startsWith('http') 
        ? rawPath.replaceAll('localhost', '192.168.1.105') 
        : "$baseUrl${rawPath.startsWith('/') ? '' : '/'}$rawPath";

    return Apartment(
        id: json['id'],
        price: json['price'],
        governorate: (json['governorate'] as String).capitalize(),
        city: (json['city'] as String).capitalize(),
        averageRating: json['average_rating'] != null 
            ? (json['average_rating'] as num).toInt() 
            : 0,
        space: json['space'] ,
        imagePath: correctedPath,
        is_favorite: json['is_favorite'] ?? false,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}