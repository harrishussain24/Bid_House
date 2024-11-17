// ignore_for_file: file_names, avoid_print, prefer_const_constructors

import 'package:bidhouse/costCalculator.dart';
import 'package:flutter/material.dart';
import 'package:bidhouse/constants.dart';
import 'package:intl/intl.dart';

class PlotInfoScreen extends StatefulWidget {
  const PlotInfoScreen({super.key});

  @override
  State<PlotInfoScreen> createState() => _PlotInfoScreenState();
}

class _PlotInfoScreenState extends State<PlotInfoScreen>
    with TickerProviderStateMixin {
  String selectedUnit = 'Marla'; //for saving area unit user will select.
  String selectedCity = 'Select City'; //for saving the city user will select.
  num floors = 0;
  String? finalCost; //for saving the final cost calculated.
  bool constructionComplete = false;
  bool constructionNotComplete = false;
  bool constructionWithMaterial = false;
  bool constructionWithoutMaterial = false;
  bool showConstructionOptions = false; // Toggle for construction options
  final TextEditingController _controller =
      TextEditingController(); //for area size
  final formatter = NumberFormat.compact(
      locale: "en_US",
      explicitSign: false); // for formatting the final calculated value.

  @override
  Widget build(BuildContext context) {
    Color color = AppConstants.appColor;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        title: const Text(
          "Plot Info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'City',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                //City DropDown *****************************************************************
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.5)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        menuWidth: MediaQuery.sizeOf(context).width * 0.8,
                        borderRadius: BorderRadius.circular(20),
                        value: selectedCity,
                        icon: Icon(Icons.arrow_drop_down, color: color),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCity = newValue!;
                          });
                        },
                        items: <String>[
                          'Select City',
                          'Islamabad',
                          'Lahore',
                          'Karachi',
                          'Rawalpindi'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Area Size',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                //Area Size TextField *****************************************************************
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: color, width: 2.0),
                    ),
                    suffixIcon: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.grey))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(20),
                          value: selectedUnit,
                          icon: Icon(Icons.arrow_drop_down, color: color),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUnit = newValue!;
                            });
                          },
                          items: <String>['Marla', 'Kanal']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    hintText: 'Enter Area Size',
                    hintStyle: TextStyle(color: color),
                  ),
                ),
                SizedBox(height: 30),
                //DropDown for more Options Button **************************************************
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showConstructionOptions = !showConstructionOptions;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        showConstructionOptions
                            ? "Less Options"
                            : "More Options",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        showConstructionOptions
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: color,
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(
                      milliseconds: 400), // Controls the speed of the animation
                  curve: Curves.easeInOut, // Smooth transition effect
                  child: showConstructionOptions
                      ? _buildConstructionOptions(color)
                      : Container(),
                ),
                SizedBox(height: 40),
                AppConstants.button(
                  buttonWidth: 0.8,
                  buttonHeight: 0.07,
                  onTap: () {
                    int area;
                    if (selectedUnit == "Kanal") {
                      area = 20 * int.parse(_controller.text.toString().trim());
                      CostCalculator.calculatingCost(
                          area: area, city: selectedCity);
                      setState(() {});
                    } else {
                      CostCalculator.calculatingCost(
                          area: int.parse(_controller.text.toString().trim()),
                          city: selectedCity);
                      setState(() {});
                    }
                  },
                  buttonText: 'Calculate Cost',
                  textSize: 20,
                  context: context,
                ),
                SizedBox(
                  height: 50,
                ),
                CostCalculator.finalCost != ''
                    ? Text(
                        'Total Estimated Cost',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  CostCalculator.finalCost,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConstructionOptions(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Floors',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        //Floors DropDown *****************************************************************
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.5)),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                elevation: 0,
                menuWidth: MediaQuery.sizeOf(context).width * 0.8,
                borderRadius: BorderRadius.circular(20),
                value: floors.toString(),
                icon: Icon(Icons.arrow_drop_down, color: color),
                onChanged: (String? newValue) {
                  setState(() {
                    floors = num.parse(newValue!);
                  });
                },
                items: <String>[
                  0.toString(),
                  1.toString(),
                  2.toString(),
                  3.toString(),
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Construction Type',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            _buildInputChip(
              label: 'Complete',
              selected: constructionComplete,
              color: color,
              onSelected: () {
                setState(() {
                  constructionComplete = true;
                  constructionNotComplete = false;
                });
              },
            ),
            SizedBox(width: 10),
            _buildInputChip(
              label: 'Grey Structure',
              selected: constructionNotComplete,
              color: color,
              onSelected: () {
                setState(() {
                  constructionComplete = false;
                  constructionNotComplete = true;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Construction Mode',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            _buildInputChip(
              label: 'With Material',
              selected: constructionWithMaterial,
              color: color,
              onSelected: () {
                setState(() {
                  constructionWithMaterial = true;
                  constructionWithoutMaterial = false;
                });
              },
            ),
            SizedBox(width: 10),
            _buildInputChip(
              label: 'Without Material',
              selected: constructionWithoutMaterial,
              color: color,
              onSelected: () {
                setState(() {
                  constructionWithoutMaterial = true;
                  constructionWithMaterial = false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onSelected,
  }) {
    return InputChip(
      label: Text(label),
      labelStyle: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      backgroundColor: selected ? color : Colors.white,
      onSelected: (_) => onSelected(),
    );
  }
}
