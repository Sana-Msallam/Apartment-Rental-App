class BookingRequestModel {
  final int id;
  final String status;
  final String startDate;
  final String endDate;
  final int apartmentId;
  final int userId;
  final double totalPrice;

  BookingRequestModel({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.apartmentId,
    required this.userId,
    required this.totalPrice,
  });

  BookingRequestModel copyWith({
    int? id,
    String? status,
    String? startDate,
    String? endDate,
    int? apartmentId,
    int? userId,
    double ?totalPrice,
  }){
    return BookingRequestModel(
      id: id?? this.id,
      status: status?? this.status,
      startDate: startDate?? this.startDate, 
      endDate: endDate?? this.endDate,
      apartmentId: apartmentId?? this.apartmentId,
      userId: userId?? this.userId,
      totalPrice: totalPrice?? this.totalPrice
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
    );
  }
}