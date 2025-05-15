part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

final  class RegisterQuantity extends DashboardEvent{
  final  String customerCode;
  final  String unitOfMeasure;
  final  int quantity;

  RegisterQuantity({required this.customerCode, required this.unitOfMeasure, required this.quantity});
  

}
class ResetDashboardState extends DashboardEvent {}
class FetchRecordsEvent extends DashboardEvent {}


