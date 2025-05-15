import 'package:cooperativeapp/InternetConnectivity/check_internet.dart';
import 'package:cooperativeapp/Screens/Dashboard/bloc/dashboard_bloc.dart';
import 'package:cooperativeapp/Screens/Dashboard/dashboard.dart';
import 'package:cooperativeapp/Screens/member_search.dart';
import 'package:cooperativeapp/Screens/searchuser.dart';
import 'package:cooperativeapp/model/offline_product.dart';
import 'package:cooperativeapp/offlineDatabase/offline_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRecordScreen extends StatefulWidget {
  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final DashboardBloc dashboardBloc = DashboardBloc();

  // Controllers
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerCodeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String? selectedUnit;
  final List<String> units = ['kg', 'liters', 'bags'];

  // void _searchMemberDialog() async {
  //   final result = await showDialog<Map<String, String>>(
  //     context: context,
  //     builder: (context) => MemberSearchDialog(),
  //   );

  //   if (result != null) {
  //     setState(() {
  //       customerNameController.text = result['name'] ?? '';
  //       customerCodeController.text = result['code'] ?? '';
  //     });
  //   }
  // }
  void _searchMemberDialog() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true, // optional, allows full-screen bottom sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CustomerBottomSheet(),
    );

    if (result != null) {
      setState(() {
        customerNameController.text = result['name'] ?? '';
        customerCodeController.text = result['code'] ?? '';
      });
    }
  }

  void _registerFarmerProduct() async {
    setState(() => _isSubmitting = true);
    if (_formKey.currentState!.validate()) {
      final customerName = customerNameController.text;
      final customerCode = customerCodeController.text;
      final quantity = quantityController.text;
      final unit = selectedUnit;
      bool isConnected = await CheckInternetCon.checkConnection();

      if (!isConnected) {
        final offlineProduct = OfflineProduct(
          customerCode: customerCode,
          unitOfMeasure: unit ?? '',
          quantity: int.parse(quantity),
        );

        await OfflineDatabaseHelper().insertOfflineProduct(offlineProduct);

        _formKey.currentState!.reset();
        customerNameController.clear();
        customerCodeController.clear();
        quantityController.clear();
        setState(() {
          selectedUnit = null;
        });
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Saved locally. Will sync when online.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }
      setState(() => _isSubmitting = false);
      dashboardBloc.add(
        RegisterQuantity(
          customerCode: customerCode,
          unitOfMeasure: unit.toString(),
          quantity: int.parse(quantity),
        ),
      );
    }
    else{
       setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    customerNameController.dispose();
    customerCodeController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      listenWhen: (previous, current) => current is DashboardActionState,
      buildWhen: (previous, current) => current is! DashboardActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DashboardInitial) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF2EBF70),
              title: const Text('Register Farmer Product'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
              ),
              actions: [
                Icon(Icons.logout,)
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 80.0,
              ),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Text
                        SizedBox(height: 16),

                        // Customer Name TextField
                        TextFormField(
                          controller: customerNameController,
                          decoration: InputDecoration(
                            labelText: 'Customer Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Customer Code TextField with Search Icon as Suffix
                        TextFormField(
                          controller: customerCodeController,
                          decoration: InputDecoration(
                            labelText: 'Customer Code',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _searchMemberDialog,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter  customer code';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Unit of Measure Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Unit of Measure',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select unit  of  measure';
                            }
                            return null;
                          },
                          items:
                              units.map((unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() => selectedUnit = value);
                          },
                        ),
                        SizedBox(height: 16),

                        // Quantity TextField
                        TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a quantity';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Register Button
                        Center(
                          child: ElevatedButton(
                            onPressed:
                                _isSubmitting ? null : _registerFarmerProduct,
                            child:
                                _isSubmitting
                                    ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Text('Register Farmer Product'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is DashboardLoadingProductState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is DashboardRegisterProductSuccessState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product registered successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            setState(() {
              customerNameController.clear();
              customerCodeController.clear();
              quantityController.clear();
              selectedUnit = null;
            });
            dashboardBloc.add(ResetDashboardState());
          });

          // Return same page UI
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 80.0,
            ),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Register Farmer Product',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: customerNameController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Customer Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: customerCodeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Customer Code',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _searchMemberDialog,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedUnit,
                        decoration: InputDecoration(
                          labelText: 'Unit of Measure',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            units.map((unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() => selectedUnit = value);
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              _isSubmitting ? null : _registerFarmerProduct,
                          child:
                              _isSubmitting
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text('Register Farmer Product'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is DashboardErrorProductState) {
          return Center(child: Text("error  occured"));
        }
        return Center(child: Text('Unexpected state'));
      },
    );
  }
}
