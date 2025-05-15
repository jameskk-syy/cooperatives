import 'dart:async'; // For debounce
import 'package:cooperativeapp/Screens/addUser/bloc/customer_bloc.dart';
import 'package:cooperativeapp/repository/searchuserrepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerBloc(CustomerRepository())..add(LoadCustomers()),
      child: BottomSheetContent(),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allEntities = [];
  List<Map<String, dynamic>> filteredEntities = [];
  Timer? _debounce; // Make it nullable

  @override
  void dispose() {
    // Cancel the debounce timer if it's not null
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel the previous debounce timer and start a new one
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterEntities(query);
    });
  }

  void _filterEntities(String query) {
    setState(() {
      filteredEntities = allEntities.where((entity) {
        final firstName = entity['firstName']?.toLowerCase() ?? '';
        final lastName = entity['lastName']?.toLowerCase() ?? '';
        final customerCode = entity['customerCode']?.toString().toLowerCase() ?? '';

        return firstName.contains(query.toLowerCase()) ||
            lastName.contains(query.toLowerCase()) ||
            customerCode.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(height: 50),
          TextField(
            controller: searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by name or code',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  _filterEntities(''); // Reset to all entities when cleared
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CustomerLoaded) {
                  if (state.customers.isEmpty) {
                    return Center(child: Text('No customers found'));
                  }

                  // Flatten the entities only once when customers are loaded
                  if (allEntities.isEmpty) {
                    allEntities = state.customers.expand((customer) => customer.entity).toList();
                    filteredEntities = List.from(allEntities); // Initialize filteredEntities
                  }

                  return ListView.builder(
                    itemCount: filteredEntities.length,
                    itemBuilder: (context, index) {
                      final entity = filteredEntities[index];

                      String firstName = entity['firstName'] ?? '';
                      String lastName = entity['lastName'] ?? '';
                      String fullName = '$firstName $lastName'.trim();

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          title: Text(
                            fullName.isNotEmpty ? fullName : 'No name',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            entity['customerCode'] ?? 'No code',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pop(context, {
                              'name': fullName.isNotEmpty ? fullName : 'No name',
                              'code': entity['customerCode']?.toString() ?? 'No code',
                            });
                          },
                        ),
                      );
                    },
                  );
                } else if (state is CustomerError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
