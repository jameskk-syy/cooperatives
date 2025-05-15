import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cooperativeapp/Screens/Dashboard/dashboard.dart';
import 'package:cooperativeapp/model/product_record.dart';
import 'package:cooperativeapp/repository/product_repo.dart';
import 'package:cooperativeapp/repository/repo.dart';
import 'package:cooperativeapp/response/products_response.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {
    });
    on<RegisterQuantity>(registerQuantity);
    on<ResetDashboardState>((event, emit) {
  emit(DashboardInitial());
});
on<FetchRecordsEvent>((event, emit) async {
  emit(DashboardLoadingProductState());

  try {
    final records = await ProductRepo.getAllProducts();
    emit(DashboardRecordsLoadedState(records: records));
  } catch (e) {
    emit(DashboardErrorProductState());
  }
});



  }

 FutureOr<void> registerQuantity(RegisterQuantity event, Emitter<DashboardState> emit) async {
  print(event.quantity);
  emit(DashboardLoadingProductState());

  try {
    // Assuming addCollection is an async method that registers the quantity
    await LoginRepository.addCollection(event.customerCode, event.quantity, event.unitOfMeasure);
    emit(DashboardRegisterProductSuccessState());
  } catch (e) {
    // Emit error state if there is an exception
    emit(DashboardErrorProductState());
    // Optionally, log the error or handle it as needed
    print('Error during product registration: $e');
  }
}


}
