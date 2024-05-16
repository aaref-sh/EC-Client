import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tt/enums/server_enums.dart';

class CreateVoucherScreen extends StatefulWidget {
  @override
  _CreateVoucherScreenState createState() => _CreateVoucherScreenState();
}

class _CreateVoucherScreenState extends State<CreateVoucherScreen> {
  final _formKey = GlobalKey<FormState>();
  VoucherType? _selectedType;
  double? _value;
  int? _creditAccountId;
  int? _debitAccountId;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<VoucherType>(
              value: _selectedType,
              onChanged: (VoucherType? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              items: VoucherType.values.map((VoucherType type) {
                return DropdownMenuItem<VoucherType>(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'النوع',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Value'),
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                _value = double.tryParse(value ?? '');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Credit Account ID'),
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                _creditAccountId = int.tryParse(value ?? '');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Debit Account ID'),
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                _debitAccountId = int.tryParse(value ?? '');
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Here you can handle the submission, for example:
                  // var request = CreateVoucherRequest(
                  //   type: _selectedType!,
                  //   value: _value!,
                  //   creditAccountId: _creditAccountId!,
                  //   debitAccountId: _debitAccountId!,
                  // );
                  // You would then pass this request to your API or data layer.
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
