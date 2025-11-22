import 'package:equatable/equatable.dart';

class Request extends Equatable {
  final int id;
  final String category;
  final String title;
  final String description;
  final String date;
  final String location;
  final String address;
  final String time;
  final int guests;
  final String status;

  const Request({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.address,
    required this.time,
    required this.guests,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        description,
        date,
        location,
        address,
        time,
        guests,
        status,
      ];
}
