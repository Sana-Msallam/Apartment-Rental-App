class BookingRequestModel {
  final int id;
  final String status;
  final String startDate;
  final String endDate;
  final int apartmentId;
  final int userId;
  final double totalPrice;
  final BookingUser? user; 

  BookingRequestModel({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.apartmentId,
    required this.userId,
    required this.totalPrice,
    this.user,
  });

  BookingRequestModel copyWith({
    int? id,
    String? status,
    String? startDate,
    String? endDate,
    int? apartmentId,
    int? userId,
    double ?totalPrice,
    BookingUser? user,
  }){
    return BookingRequestModel(
      id: id?? this.id,
      status: status?? this.status,
      startDate: startDate?? this.startDate, 
      endDate: endDate?? this.endDate,
      apartmentId: apartmentId?? this.apartmentId,
      userId: userId?? this.userId,
      totalPrice: totalPrice?? this.totalPrice,
      user: user ?? this.user,
      );
  }

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      id: json['id'],
      status: json['status'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      apartmentId: json['apartment_id'],
      userId: json['user_id'],
      totalPrice: (json['total_price'] as num).toDouble(),
      user: json['user'] != null ? BookingUser.fromJson(json['user']) : null,
    );
  }
}
class BookingUser {
  final int id;
  final String firstName;
  final String lastName;

  BookingUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
  String get fullName => '$firstName $lastName';
}