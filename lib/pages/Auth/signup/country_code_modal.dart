import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import '../../../constants/country_code_list.dart';

class CountryCodeModel extends StatefulWidget {
  const CountryCodeModel({super.key, required this.onCountrySelected});
  final Function(String) onCountrySelected;

  @override
  State<CountryCodeModel> createState() => _CountryCodeModelState();
}

class _CountryCodeModelState extends State<CountryCodeModel> {
  List<Map<String, dynamic>> filteredCountries = List.from(countries);

  void filterCountries(String query) {
    setState(() {
      filteredCountries =
          countries.where((country) => country["name"]!.toLowerCase().contains(query.toLowerCase()) || country["dial_code"]!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 550,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 470,
                  child: TextField(
                    onChanged: (value) => filterCountries(value),
                    decoration: const InputDecoration(
                      hintText: 'Search for a country',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.close,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = filteredCountries[index];
                  return ListTile(
                    leading: Text(country["dial_code"]),
                    title: AppText(
                      text: country["name"],
                    ),
                    onTap: () {
                      widget.onCountrySelected(country["dial_code"]);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Country {
  final String name;
  final String flag;
  final String code;
  final String dialCode;

  Country({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      flag: json['flag'],
      code: json['code'],
      dialCode: json['dial_code'],
    );
  }
}
