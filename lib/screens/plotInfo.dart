// ignore_for_file: file_names, avoid_print, prefer_const_constructors, must_be_immutable, use_build_context_synchronously

import 'package:bidhouse/costCalculator.dart';
import 'package:bidhouse/models/adsmodel.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bidhouse/constants.dart';
import 'package:intl/intl.dart';

class PlotInfoScreen extends StatefulWidget {
  AuthenticationModel userData;
  PlotInfoScreen({super.key, required this.userData});

  @override
  State<PlotInfoScreen> createState() => _PlotInfoScreenState();
}

class _PlotInfoScreenState extends State<PlotInfoScreen>
    with TickerProviderStateMixin {
  String selectedUnit = 'Marla'; //for saving area unit user will select.
  String selectedCity = 'Select City'; //for saving the city user will select.
  num floors = 0;
  String consType = "Not Selected", consMode = "Not Selected";
  bool constructionComplete = false;
  bool constructionNotComplete = false;
  bool constructionWithMaterial = false;
  bool constructionWithoutMaterial = false;
  bool showConstructionOptions = false;
  final TextEditingController _controller = TextEditingController();
  final formatter = NumberFormat.compact(
      locale: "en_US",
      explicitSign: false); // for formatting the final calculated value.
  CollectionReference datacollection =
      FirebaseFirestore.instance.collection('Ads');

  //saving data to database
  saveData(AdsModel ad) async {
    try {
      AppConstants.showLoadingDialog(context: context, title: "Uploading ...!");
      // Getting a new document reference from Firestore
      DocumentReference newDocument = datacollection.doc();
      // Setting the document ID as the ad's ID
      ad.id = newDocument.id;
      // Converting the ad model to JSON
      var data = ad.toJson();
      // Saving data to Firestore
      await newDocument.set(data).whenComplete(() {
        Navigator.pop(context);
      });
      // Showing success message
      AppConstants.showAlertDialog(
        context: context,
        title: "Success",
        content: "Data Saved ...!",
      );
      // Clearing all the values
      setState(() {
        selectedCity = 'Select City';
        selectedUnit = 'Marla';
        floors = 0;
        consType = "Not Selected";
        consMode = "Not Selected";
        constructionComplete = false;
        constructionNotComplete = false;
        constructionWithMaterial = false;
        constructionWithoutMaterial = false;
        showConstructionOptions = false;
        CostCalculator.finalCost = '';
        _controller.clear();
      });
    } catch (error) {
      // Showing error message
      Navigator.pop(context);
      AppConstants.showAlertDialog(
        context: context,
        title: "Error",
        content: error.toString(),
      );
      print('Error: $error');
    }
  }

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
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'lib/assets/bg3.png',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.5),
            ),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
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
                      setState(() {});
                    } else {
                      area = int.parse(_controller.text.toString().trim());
                    }
                    print(floors.toString() + consMode + consType);
                    CostCalculator.valuesCollector(
                      area: area,
                      city: selectedCity,
                      selectedFloors: floors,
                      consMode: consMode,
                      consType: consType,
                    );
                    setState(() {});
                  },
                  buttonText: 'Calculate Cost',
                  textSize: 20,
                  context: context,
                ),
                SizedBox(
                  height: 50,
                ),
                CostCalculator.finalCost != ''
                    ? const Text(
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
                SizedBox(
                  height: 10,
                ),
                CostCalculator.finalCost == ''
                    ? Container()
                    : AppConstants.button(
                        buttonWidth: 0.5,
                        buttonHeight: 0.05,
                        onTap: () {
                          num checkingFloors;
                          if (floors == 0) {
                            checkingFloors = 2;
                          } else {
                            checkingFloors = floors;
                          }
                          var data = AdsModel(
                            id: "",
                            city: selectedCity,
                            areaSize:
                                "${_controller.text.toString()} $selectedUnit",
                            floors: checkingFloors.toString(),
                            constructionType: consType,
                            constructionMode: consMode,
                            totalCost: CostCalculator.finalCost,
                            userId: widget.userData.id,
                            userName: widget.userData.name,
                            userEmail: widget.userData.email,
                            userImageUrl: widget.userData.imageUrl!,
                            userPhoneNo: widget.userData.phoneNo,
                          );
                          saveData(data);
                        },
                        buttonText: "Post Ad",
                        textSize: 17,
                        context: context,
                      ),
                const SizedBox(
                  height: 40,
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
                  consType = "Complete";
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
                  consType = "Grey Structure";
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
                  consMode = "With Material";
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
                  consMode = "Without Material";
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
