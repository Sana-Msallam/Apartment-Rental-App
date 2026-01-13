class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });
  factory NotificationModel.fromJson(Map<String, dynamic> json){
    final innerData = json['data']as Map<String,dynamic>;
    return NotificationModel(
      id: json['id'],
      title: innerData['title'] ?? '',
      body: innerData['body'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['read_at'] != null,
    );
      }
}