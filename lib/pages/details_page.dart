import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {

  final Map rates;

  const DetailsPage({
    super.key,
    required this.rates
  });

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangesRates = rates.values.toList();

    return  Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: _currencies.length,
            itemBuilder: (_context, _index){
            String _currency = _currencies[_index].toString().toUpperCase();
            String _rates = _exchangesRates[_index].toString();
            return ListTile( title:  Text("$_currency : $_rates" , style: TextStyle(color: Colors.white),),);
            }
        ),
      ),

    );
  }
}
