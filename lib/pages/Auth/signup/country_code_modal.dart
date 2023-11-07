import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import '../../../constants/country_code_list.dart';
import 'package:country_flags/country_flags.dart';

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
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 550,
        padding: const EdgeInsets.only(top: 16, left: 16, right: 5, bottom: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) => filterCountries(value),
                    decoration: const InputDecoration(
                      isDense: true,
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
                    contentPadding: const EdgeInsets.all(0),
                    // trailing: Container(
                    //   margin: const EdgeInsets.only(right: 10),
                    //   child: CountryFlag.fromCountryCode(
                    //     country["code"],
                    //     height: 26,
                    //     width: 26,
                    //   ),
                    // ),
                    // leading: AppText(text: country["dial_code"]),
                    // title: AppText(
                    //   text: country["name"],
                    // ),
                    //  trailing: Container(
                    //   margin: const EdgeInsets.only(right: 10),
                    //   child: CountryFlag.fromCountryCode(
                    //     country["code"],
                    //     height: 26,
                    //     width: 26,
                    //   ),
                    // ),
                    leading: CountryFlag.fromCountryCode(
                      country["code"],
                      height: 26,
                      width: 26,
                    ),
                    title: AppText(text: "${country["name"]}"),
                    trailing: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: AppText(text: "${country["dial_code"]}"),
                    ),
                    horizontalTitleGap: 5,
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

String getFlagEmojiFromCountryCode(String countrycode) {
  // Ensure the country code is in uppercase
  countrycode = countrycode.toUpperCase();

  // Replace each letter in the country code with the corresponding flag emoji
  String flag = countrycode.replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

  return flag;
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
