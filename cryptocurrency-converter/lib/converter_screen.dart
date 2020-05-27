import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'SEK';
  String selectedCryptoCurrency = 'BTC';
  String loadingCurrency = '?';

  DropdownButton<String> androidDropDownFlatCurrency() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(currenciesList[i]), value: currenciesList[i]));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: menuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  DropdownButton<String> androidDropDownCryptoCurrency()  {
    List<DropdownMenuItem<String>> menuItems = [];
    for (int i = 0; i < cryptoList.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(cryptoList[i]), value: cryptoList[i]));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: menuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iOSFlatCurrencyPicker() {
    List<Widget> menuItems = [];
    for (String item in currenciesList) {
      menuItems.add(Text(item));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightGreen,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getExchangeRate();
        });
      },
      children: menuItems,
    );
  }

  CupertinoPicker iOSCryptoCurrencyPicker() {
    List<Widget> menuCryptoItems = [];
    for (String crypto in cryptoList) {
      menuCryptoItems.add(Text(crypto));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightGreen,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCryptoCurrency = cryptoList[selectedIndex];
          getExchangeRate();
        });
      },
      children: menuCryptoItems,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExchangeRate();
  }

  void getExchangeRate () async {
    var getCurrencies = await CoinData().createConvert(selectedCryptoCurrency, selectedCurrency);
    double getExchangeRate = getCurrencies['rate'];
    setState(() {
      loadingCurrency = getExchangeRate.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptocurrency Converter 🤑'),
        backgroundColor: Colors.lightGreen.shade900,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightGreen,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 28.0),
                child: Text(
                  'CONVERTED CURRENCIES\n\n'
                      '1 $selectedCryptoCurrency = $loadingCurrency $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 150.0,
                  alignment: Alignment.bottomLeft,
                  //padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.lightGreen,
                  child: Platform.isIOS ? iOSCryptoCurrencyPicker() : androidDropDownCryptoCurrency(),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150.0,
                  alignment: Alignment.bottomRight,
                  //padding: EdgeInsets.only(bottom: 90.0),
                  color: Colors.lightGreen,
                  child: Platform.isIOS ? iOSFlatCurrencyPicker() : androidDropDownFlatCurrency(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
