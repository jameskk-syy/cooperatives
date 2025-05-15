import 'package:cooperativeapp/Screens/Dashboard/bloc/dashboard_bloc.dart';
import 'package:cooperativeapp/Screens/PendingRecords/pending_records.dart';
import 'package:cooperativeapp/Screens/addUser/add_record.dart';
import 'package:cooperativeapp/Screens/all_records.dart' show RecordsScreen;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

final List<Widget> _pages = [
  AddRecordScreen(),
  BlocProvider(
    create: (context) => DashboardBloc()..add(FetchRecordsEvent()), // use your actual event
    child: RecordsScreen(),
  ),
  BlocProvider(
    create: (context) => DashboardBloc()..add(FetchRecordsEvent()), // use your actual event
    child: OfflineSyncPage(),
  ),
];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF2EBF70),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add , color: Colors.black,), label: 'Add Record',),
          BottomNavigationBarItem(icon: Icon(Icons.list, color: Colors.black,), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.save, color: Colors.black,), label: 'Pending Records'),
          // BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.black,), label: 'Pending Records'),
        ],
      ),
    );
  }
}
