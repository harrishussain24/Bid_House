// ignore_for_file: file_names, avoid_print, unused_element

import 'package:intl/intl.dart';

class CostCalculator {
  static bool floors = true;
  static bool constructionType = true;
  static bool constructionMode = true;
  static String finalCost = '';
  static num totalCost = 0;
  static num coveredArea = 0;
  static num greyStructureCost = 0;
  static num furnishingCost = 0;

  static final formatter = NumberFormat.compact(
      locale: "en_US",
      explicitSign: false); // for formatting the final calculated value.

  static num checkingAreaUnit({required num area}) {
    num totalArea = 270 * area;
    if (area >= 5) {
      return coveredArea = (75 * totalArea) / 100;
    } else {
      return coveredArea = (85 * totalArea) / 100;
    }
  }

  //checking if user has selected number of floors or not.
  static bool checkingFloors(num selectedFloors) {
    if (selectedFloors == 0) {
      return false;
    } else {
      return true;
    }
  }

  //checking if user has selected construction type or not.
  static bool checkingConsType(String constructionType) {
    if (constructionType == '') {
      return false;
    } else {
      return true;
    }
  }

  //checking if user has selected construction mode or not.
  static bool checkingConsMode(String constructionMode) {
    if (constructionMode == '') {
      return false;
    } else {
      return true;
    }
  }

  static String calculatingCost({
    required String city,
    required num area,
    required num selectedFloors,
    required String consType,
    required String consMode,
  }) {
    checkingAreaUnit(area: area);
    // Calculating Cost for Islamabad City.
    if (city == "Islamabad") {
      greyStructureCost = 2750;
      furnishingCost = 2400;

      //only GreyStructure selected
      if (consType == "Grey Structure" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      //only Complete Selected
      else if (consType == "Complete" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Without Material Selected
      else if (consType == "Not Selected" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost - 320, furnCost: furnishingCost);
      }
      //only With Material Selected
      else if (consType == "Not Selected" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Floors Selected
      else if (consType == "Not Selected" &&
          consMode == "Not Selected" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure With Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      // GreyStructure Without Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: (greyStructureCost - 320), furnCost: 0);
      }
      // GreyStructure With Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure Without Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost - 250) * selectedFloors * coveredArea;
      }
      //Complete With Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //Complete Without Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost - 50);
      }
      //Complete With Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      }
      //Complete Without Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      } else {
        /*If user just select city and enter the area than this default 
        double story fully furnished cost for the entered area will 
        be calculated for that City. */
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else if (city == "Lahore") {
      //Lahore
      greyStructureCost = 2760;
      furnishingCost = 2450;

      //only GreyStructure selected
      if (consType == "Grey Structure" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      //only Complete Selected
      else if (consType == "Complete" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Without Material Selected
      else if (consType == "Not Selected" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost - 320, furnCost: furnishingCost);
      }
      //only With Material Selected
      else if (consType == "Not Selected" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Floors Selected
      else if (consType == "Not Selected" &&
          consMode == "Not Selected" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure With Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      // GreyStructure Without Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: (greyStructureCost - 320), furnCost: 0);
      }
      // GreyStructure With Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure Without Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost - 250) * selectedFloors * coveredArea;
      }
      //Complete With Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //Complete Without Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //Complete With Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      }
      //Complete Without Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      } else {
        /*If user just select city and enter the area than this default 
        double story fully furnished cost for the entered area will 
        be calculated for that City. */
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else if (city == "Karachi") {
      //Karachi
      greyStructureCost = 2750;
      furnishingCost = 2440;

      //only GreyStructure selected
      if (consType == "Grey Structure" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      //only Complete Selected
      else if (consType == "Complete" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Without Material Selected
      else if (consType == "Not Selected" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost - 320, furnCost: furnishingCost);
      }
      //only With Material Selected
      else if (consType == "Not Selected" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Floors Selected
      else if (consType == "Not Selected" &&
          consMode == "Not Selected" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure With Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      // GreyStructure Without Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: (greyStructureCost - 320), furnCost: 0);
      }
      // GreyStructure With Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure Without Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost - 250) * selectedFloors * coveredArea;
      }
      //Complete With Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //Complete Without Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //Complete With Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      }
      //Complete Without Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      } else {
        /*If user just select city and enter the area than this default 
        double story fully furnished cost for the entered area will 
        be calculated for that City. */
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else if (city == "Rawalpindi") {
      //Rawalpindi
      greyStructureCost = 2650;
      furnishingCost = 2350;

      //only GreyStructure selected
      if (consType == "Grey Structure" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      //only Complete Selected
      else if (consType == "Complete" &&
          consMode == "Not Selected" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Without Material Selected
      else if (consType == "Not Selected" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost - 320, furnCost: furnishingCost);
      }
      //only With Material Selected
      else if (consType == "Not Selected" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //only Floors Selected
      else if (consType == "Not Selected" &&
          consMode == "Not Selected" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure With Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: 0);
      }
      // GreyStructure Without Material no Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: (greyStructureCost - 320), furnCost: 0);
      }
      // GreyStructure With Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70) * selectedFloors * coveredArea;
      }
      // GreyStructure Without Material Floor Selected
      else if (consType == "Grey Structure" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost - 250) * selectedFloors * coveredArea;
      }
      //Complete With Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //Complete Without Material No Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors == 0) {
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      //Complete With Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "With Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      }
      //Complete Without Material Floor Selected
      else if (consType == "Complete" &&
          consMode == "Without Material" &&
          selectedFloors != 0) {
        totalCost = (greyStructureCost + 70 + furnishingCost) *
            selectedFloors *
            coveredArea;
      } else {
        /*If user just select city and enter the area than this default 
        double story fully furnished cost for the entered area will 
        be calculated for that City. */
        totalCost = noExtraOptionSelected(
            greyStructCost: greyStructureCost, furnCost: furnishingCost);
      }
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else {
      print("Error: City Not Recognized");
      return 'Error';
    }
  }

  static checkingOtherOptions({
    required String city,
    required num area,
    required num selectedFloors,
    required String consType,
    required String consMode,
  }) {
    floors = checkingFloors(selectedFloors);
    constructionType = checkingConsType(consType);
    constructionMode = checkingConsMode(consMode);

    if (floors && constructionType && constructionMode) {
      print(selectedFloors);
      print(consType);
      print(consMode);
    } else {
      print('Error');
      print(selectedFloors);
      print(consType);
      print(consMode);
    }
  }

  static num noExtraOptionSelected(
      {required num greyStructCost, required num furnCost}) {
    //greyStructure Cost for 1st floor.
    num fisrtFloor = (greyStructCost + 70) * coveredArea;
    //greyStructure Cost for 2nd floor.
    num secondFloor = (greyStructCost - 250) * coveredArea;
    //Furnishing Cost.
    num fCost = furnCost * 2 * coveredArea;
    return fisrtFloor + secondFloor + fCost;
  }
}
