class Apartment{
  final int id;
  final int price;
  final String governorate;
  final String city;
  final int space;
  final int ?averageRating; 
  final String imagePath;


  Apartment({
    required this.id,
    required this.price,
    required this.governorate,
    required this.city,
    required this.space,
    required this.imagePath,
     this.averageRating,
});

  factory Apartment.fromJson(Map<String, dynamic> json) {
    String rawPath = json['main_image'] != null ? json['main_image']['path'] : '';
    
    String baseUrl = "http://192.168.1.105:8000"; 
    String correctedPath = rawPath.startsWith('http') 
        ? rawPath.replaceAll('localhost', '192.168.1.105') 
        : "$baseUrl${rawPath.startsWith('/') ? '' : '/'}$rawPath";

    return Apartment(
        id: json['id'],
        price:json['price'],
        governorate:(json['governorate'] as String).capitalize(),
        city:(json['city'] as String).capitalize(),
averageRating: json['average_rating'] != null 
        ? (json['average_rating'] as num).toInt() 
        : 0,

     space:json['space'] ,
        imagePath: correctedPath,
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}