import 'dart:convert';

import 'package:coin_cap/pages/details_page.dart';
import 'package:coin_cap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;
  String _selecteCoins  = "bitcoin";

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
            mainAxisSize:  MainAxisSize.max,
            crossAxisAlignment:  CrossAxisAlignment.center,
            children: [
              _selectedCoinDropdown(),
              _dataShowcase()

            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown(){
    List<String> _coins = ["bitcoin", "ethereum", "tether", "cardano", "ripple"];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value : e, child: Text(e, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight:  FontWeight.w600),),
          ),
    ).toList();
    return DropdownButton(
        items: _items,
        value: _selecteCoins, // set the value of dropdown
        dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
        iconSize: 30,
        underline: Container(),
        icon: Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.white,
        ),
        onChanged: (dynamic _value){ // updating  the value of the dropdown
          setState(() {
            _selecteCoins = _value;
          });
        }
    );
  }

  Widget _dataShowcase(){
    return FutureBuilder(
      future: _http!.getResponse("/coins/$_selecteCoins"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot){

        if(_snapshot.hasData){
          Map _data = jsonDecode(_snapshot.data.toString());
          num _usdPrice = _data["market_data"]["current_price"]["usd"];
          /// this works as an array for json data access. market_data -> current_price -> usd. to access usd. we have to get the  market data array then current price and the finally usd.
          num _change24h = _data["market_data"]["price_change_24h"];
          String _image_url = _data["image"]["large"];
          String _coinData = _data["description"]["en"];

          Map _exchangeRatesData = _data["market_data"]["current_price"];
         // print(_exchangeRatesData);


          return Column(
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext _context){
                    return DetailsPage(rates: _exchangeRatesData); // sending the exchnage rates to details page.
                  })
                  );
                },
                  child: _coinImage(_image_url)
              ),

              _currentPriceWidget(_usdPrice), // formatting the usd dollar text
              _percentChangeWdget(_change24h),
              _descriptionCardWidget(_coinData)
            ],
          );

        }
        else{
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        },
        );
  }

  Widget _currentPriceWidget(num _rate){
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color:  Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 30
      ),
    );
  }

  Widget _percentChangeWdget(num _change){
    return Text(
      "${_change.toString()}%",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w300
      ),

    );
  }

  Widget _coinImage(String _imgURL){

    return Container(
      height:  _deviceHeight! * 0.15,
      width:  _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image:  DecorationImage(
          image:  NetworkImage(_imgURL)
        )
      ),
    );

  }

  Widget _descriptionCardWidget(String _description){
    return SafeArea(
      child: Container(
        height: _deviceHeight! * 0.5,
        width:  _deviceWidth! * 1,
        margin: EdgeInsets.symmetric(
          vertical:  _deviceHeight! * 0.05,
        ),
        padding: EdgeInsets.symmetric(
          vertical:  _deviceHeight! * 0.01,
          horizontal: _deviceHeight! * 0.01,
        ),

        color: const Color.fromRGBO(83, 88, 206, 0.5),

        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            _description,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),

      ),
    );
  }




}
