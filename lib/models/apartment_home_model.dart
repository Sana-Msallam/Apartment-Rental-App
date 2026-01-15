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
    String rawPath = '';
    if (json['main_image'] != null && json['main_image'] is Map) {
      rawPath = json['main_image']['path'] ?? '';
    }

    String baseUrl = "http://192.168.1.102:8000";
    String correctedPath = "";

    if (rawPath.isNotEmpty) {
      if (rawPath.startsWith('http')) {
        correctedPath = rawPath.replaceAll('localhost', '192.168.1.102');
      } else {
        correctedPath = "$baseUrl${rawPath.startsWith('/') ? '' : '/'}$rawPath";
      }
    }

    return Apartment(
      id: json['id'] ?? 0,
      price: json['price'] ?? 0,
      governorate: (json['governorate'] as String? ?? '').capitalize(),
      city: (json['city'] as String? ?? '').capitalize(),
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toInt()
          : 0,
      space: json['space'] ?? 0,
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