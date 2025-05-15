part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent {}

class LoadCustomers extends CustomerEvent {}

class SearchCustomers extends CustomerEvent {
  final String query;
  SearchCustomers(this.query);
}
