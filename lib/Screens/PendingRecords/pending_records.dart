import 'package:cooperativeapp/InternetConnectivity/check_internet.dart';
import 'package:cooperativeapp/Screens/Dashboard/bloc/dashboard_bloc.dart';
import 'package:cooperativeapp/Screens/Dashboard/dashboard.dart';
import 'package:cooperativeapp/model/offline_product.dart';
import 'package:cooperativeapp/offlineDatabase/offline_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineSyncPage extends StatefulWidget {
  @override
  _OfflineSyncPageState createState() => _OfflineSyncPageState();
}

class _OfflineSyncPageState extends State<OfflineSyncPage> {
  List<OfflineProduct> _offlineProducts = [];
  bool _isSyncing = false;
  DashboardBloc dashboardBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _loadOfflineProducts();
  }

  Future<void> _loadOfflineProducts() async {
    final products = await OfflineDatabaseHelper().getAllOfflineProducts();
    setState(() {
      _offlineProducts = products;
    });
  }

  Future<void> _syncOfflineProducts() async {
    setState(() => _isSyncing = true);
    bool isConnected = await CheckInternetCon.checkConnection();

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isSyncing = false);
      return;
    }
    for (var product in _offlineProducts) {
      dashboardBloc.add(
        RegisterQuantity(
          customerCode: product.customerCode,
          unitOfMeasure: product.unitOfMeasure,
          quantity: product.quantity,
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return BlocConsumer<DashboardBloc, DashboardState>(
    bloc: dashboardBloc,
  listenWhen: (previous, current) => 
    current is DashboardRegisterProductSuccessState || current is DashboardActionState,
    buildWhen: (previous, current) => current is! DashboardActionState,  
    listener: (context, state) async {
      if (state is DashboardRegisterProductSuccessState) {
        await OfflineDatabaseHelper().clearOfflineData();
        await _loadOfflineProducts();

        setState(() => _isSyncing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All data synced successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
      else  if(state is  DashboardErrorProductState){
        setState(() => _isSyncing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("something wrong  happened"),
            backgroundColor: Colors.red,
          ),);
      }
    },
    builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2EBF70),
          title: const Text("Pending Collections"),
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
        body: _offlineProducts.isEmpty
            ? const Center(child: Text('No offline data'))
            : ListView.builder(
                itemCount: _offlineProducts.length,
                itemBuilder: (context, index) {
                  final product = _offlineProducts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.storage, color: Colors.blue),
                        title: Text('Customer Code: ${product.customerCode}'),
                        subtitle: Text(
                            '${product.quantity} ${product.unitOfMeasure}'),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isSyncing ? null : _syncOfflineProducts,
          backgroundColor: _isSyncing ? Colors.grey : Colors.blue,
          child: _isSyncing
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Icon(Icons.cloud_upload, color: Colors.white,),
        ),
      );
    },
  );
}
}
