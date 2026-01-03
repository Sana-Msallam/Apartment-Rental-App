
class ReviewRequest {
  final int apartmentId;
  final int stars;
  final String? comment;

  ReviewRequest({
    required this.apartmentId,
    required this.stars,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
    'apartment_id': apartmentId,
    'stars': stars,
    'comment': comment,
  };
}