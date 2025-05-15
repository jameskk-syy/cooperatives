import 'package:flutter/material.dart';

class MemberSearchDialog extends StatelessWidget {
  final List<Map<String, String>> mockMembers = [
    {'name': 'Nakusi Aidah', 'code': 'HO/I/001362'},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Member'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: mockMembers.length,
          itemBuilder: (context, index) {
            final member = mockMembers[index];
            return ListTile(
              title: Text(member['name']!),
              subtitle: Text(member['code']!),
              onTap: () {
                Navigator.pop(context, member);
              },
            );
          },
        ),
      ),
    );
  }
}
