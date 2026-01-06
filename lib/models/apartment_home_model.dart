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
    String rawPath = '';

    // التحقق من وجود الصورة في main_image
    if (json['main_image'] != null && json['main_image'] is Map) {
      // السيرفر يرسل الرابط في حقل اسمه 'path'
      rawPath = json['main_image']['path'] ?? '';
    } 

    String baseUrl = "http://192.168.1.102:8000";
    String correctedPath = "";

    if (rawPath.isNotEmpty) {
      // إذا كان الرابط كاملاً ويبدأ بـ http، نأخذه كما هو مع تبديل localhost للاحتياط
      if (rawPath.startsWith('http')) {
        correctedPath = rawPath.replaceAll('localhost', '192.168.1.102');
      } else {
        // إذا كان الرابط ناقصاً (يبدأ بـ /storage مثلاً)، ندمجه مع الـ baseUrl
        correctedPath = "$baseUrl${rawPath.startsWith('/') ? '' : '/'}$rawPath";
      }
    }

    // طباعة للتشخيص (اختياري)
     print("Final Corrected Path: $correctedPath");

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
    );
}
}
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}