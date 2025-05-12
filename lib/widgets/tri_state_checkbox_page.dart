import 'package:flutter/material.dart';
import 'tri_state_checkbox.dart';

class TriStateCheckboxPage extends StatefulWidget {
  const TriStateCheckboxPage({Key? key}) : super(key: key);

  @override
  State<TriStateCheckboxPage> createState() => _TriStateCheckboxExampleState();
}

class _TriStateCheckboxExampleState extends State<TriStateCheckboxPage> {
  bool? _parentValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkbox Lab4'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TriStateCheckbox(
              isParent: true,
              label: 'Select All',
              value: _parentValue,
              onChanged: (bool? value) {
                setState(() {
                  _parentValue = value;
                });
              },
              children: const [
                Text('Option 1'),
                Text('Option 2'),
                Text('Option 3'),
                Text('Option 4'),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Parent state:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_parentValue == null
                ? 'Partially checked'
                : _parentValue!
                    ? 'Checked'
                    : 'Unchecked'),
          ],
        ),
      ),
    );
  }
} 