
class ApartmentModel{
final double price;
final int rooms;                    
  final int bathrooms;                
  final double space;              
  final int floor;              
  final String titleDeed;             
  final String governorate;           
  final String city;                  
  final List<String> imageUrls;        

  ApartmentModel({
    required this.price,
    required this.rooms,
    required this.bathrooms,
    required this.space,
    required this.floor,
    required this.titleDeed,
    required this.governorate,
    required this.city,
    required this.imageUrls,
  });


}