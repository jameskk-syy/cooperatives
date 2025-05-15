part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}
sealed class DashboardActionState extends DashboardState {}

final class DashboardInitial extends DashboardState {}
final class DashboardRegisterProductSuccessState extends DashboardState {
}
final class DashboardErrorProductState extends DashboardState {
}
final class DashboardLoadingProductState extends DashboardState {
}
class DashboardRecordsLoadedState extends DashboardState {
  final List<ProductRecord> records;

  DashboardRecordsLoadedState({required this.records});
}


