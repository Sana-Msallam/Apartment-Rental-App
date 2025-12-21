class Apartment{
  final int id;
  final int price;
  final String governorate;
  final String city;
  final int space;
  final String imagePath;


  Apartment({
    required this.id,
    required this.price,
    required this.governorate,
    required this.city,
    required this.space,
    required this.imagePath,
});
  factory Apartment.fromJson(Map<String,dynamic> json){
    String rawPath = json['main_image']['path']?? '';
    // String localAsset = "assets/images/apartment_default.jpg"; 
    
    
    String  localAsset = "assets/images/${rawPath.split('/').last}";

    return Apartment(
        id: json['id'],
        price:json['price'],
        governorate:json['governorate'],
        city:json['city'],
        space:json['space'] ,
        imagePath: localAsset,
    );
  }
}