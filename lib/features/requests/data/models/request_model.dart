import '../../domain/entities/request.dart';

class RequestModel extends Request {
  const RequestModel({
    required super.id,
    required super.category,
    required super.title,
    required super.description,
    required super.date,
    required super.location,
    required super.address,
    required super.time,
    required super.guests,
    required super.status,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      time: json['time'] as String,
      guests: json['guests'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'address': address,
      'time': time,
      'guests': guests,
      'status': status,
    };
  }
}
