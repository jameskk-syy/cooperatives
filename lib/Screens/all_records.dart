import 'package:cooperativeapp/Screens/Dashboard/bloc/dashboard_bloc.dart';
import 'package:cooperativeapp/Screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting the date

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2EBF70),
        title: const Text("Today's Collections"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listenWhen: (previous, current) => current is DashboardActionState,
        buildWhen: (previous, current) => current is! DashboardActionState,
        listener: (context, state) {
          // Handle any side effects here
        },
        builder: (context, state) {
          if (state is DashboardRecordsLoadedState) {
            if (state.records.isEmpty) {
              return const Center(
                child: Text("No records found.", style: TextStyle(fontSize: 16)),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: ListView.separated(
                itemCount: state.records.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final record = state.records[index];

                  // Format the date string
                  String formattedDate = '';
                  if (record.postedTime != null) {
                    try {
                      final dateTime = DateTime.parse(record.postedTime!);
                      formattedDate = DateFormat.yMMMd().add_jm().format(dateTime);
                    } catch (_) {
                      formattedDate = record.postedTime!;
                    }
                  }

                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Quantity Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                record.customerName ?? "Unknown",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Qty: ${record.quantity ?? 0}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Date Below
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (state is DashboardErrorProductState) {
            return const Center(child: Text("Failed to load records."));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
