class BookingRequestModel {
  final int id;
  final String status;
  final String startDate;
  final String endDate;
  final int apartmentId;
  final int userId;
  final int totalPrice;

  BookingRequestModel({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.apartmentId,
    required this.userId,
    required this.totalPrice,
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      id: json['id'],
      status: json['status'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      apartmentId: json['apartment_id'],
      userId: json['user_id'],
      totalPrice: json['total_price'],
    );
  }
}