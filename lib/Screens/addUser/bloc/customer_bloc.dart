import 'package:bloc/bloc.dart';
import 'package:cooperativeapp/repository/searchuserrepo.dart';
import 'package:cooperativeapp/response/customerresponse.dart';
import 'package:meta/meta.dart';

part 'customer_event.dart';
part 'customer_state.dart';
class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc(this.customerRepository) : super(CustomerInitial()) {
    on<LoadCustomers>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customer = await customerRepository.fetchCustomers('');
         print(customer);
        emit(CustomerLoaded(customers: [customer]));
      } catch (e) {
        emit(CustomerError(message: e.toString()));
      }
    });
    on<SearchCustomers>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customer = await customerRepository.fetchCustomers(event.query);
        print(customer);
        emit(CustomerLoaded(customers: [customer]));
      } catch (e) {
        emit(CustomerError(message: e.toString())); 
      }
    });
  }
}
