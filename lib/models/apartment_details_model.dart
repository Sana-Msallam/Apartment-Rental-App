
class ApartmentDetail{
  final int id;
final double price; // تغيير لـ double ليتطابق مع الـ Migration
  final int rooms;                    
  final int bathrooms;                
  final int space;              
  final int floor; 
  final String description;  
  final String builtDate; 
  final String titleDeed; 
  final String governorate;           
  final String city;
  final String owner_phone;   
  final String first_name;
  final String last_name;                    
  final List<String> imageUrls;   

  ApartmentDetail({
    required this.id,
    required this.price,
    required this.rooms,
    required this.bathrooms,
    required this.space,
    required this.floor,
    required this.description,
    required this.builtDate,
    required this.titleDeed,
    required this.governorate,
    required this.city,
    required this.owner_phone,  
    required this.first_name,
    required this.last_name, 
    required this.imageUrls,
  });

  factory ApartmentDetail.fromJson(Map<String,dynamic> json){
    var imageList =json['apartment_images'] as List?? [];
    List<String> parsedImages =imageList.map((img){
      String path =img['path']?? '';
      return path.replaceAll('localhost', '192.168.1.107');
    }).toList();
    return ApartmentDetail(
     id: json['id'],
price: (json['price'] as num? ?? 0.0).toDouble(),
      rooms: json['rooms'],
      bathrooms: json['bathrooms'],
      space: json['space'],
      floor: json['floor'],
      description: json['description'] ?? '',
      builtDate: json['built_date'] ?? '',
      titleDeed: json['title_deed']??'',
      governorate: (json['governorate'] as String).capitalize()?? '',
      city: (json['city'] as String).capitalize() ?? '',
      owner_phone: json['owner_phone'] ?? '',
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      imageUrls: parsedImages,
      );
  }
  

  }
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

