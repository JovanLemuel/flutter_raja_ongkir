part of 'models.dart';

class Costs extends Equatable {
  final String? service;
  final String? description;
  final List<Cost>? cost;

  const Costs({this.service, this.description, this.cost});

  factory Costs.fromJson(Map<String, dynamic> json) => Costs(
        service: json['service'] as String?,
        description: json['description'] as String?,
        cost: (json['cost'] as List<dynamic>?)
            ?.map((e) => Cost.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'service': service,
        'description': description,
        'cost': cost?.map((e) => e.toJson()).toList(),
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [service, description, cost];
}
