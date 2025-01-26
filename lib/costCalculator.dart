// ignore_for_file: file_names, avoid_print, unused_element

import 'package:intl/intl.dart';

class CostCalculator {
  static String finalCost = '';
  static num totalCost = 0;
  static num coveredArea = 0;
  static late num greyStructureCost;
  static late num furnishingCost;

  static final formatter = NumberFormat.compact(
      locale: "en_US",
      explicitSign: false); // for formatting the final calculated value.

  static valuesCollector({
    required String city,
    required num area,
    required num selectedFloors,
    required String consType,
    required String consMode,
  }) {
    num finalArea = checkingAreaUnit(area: area);
    cityChecker(city, finalArea, selectedFloors, consType, consMode);
  }

  static num checkingAreaUnit({required num area}) {
    num totalArea = 270 * area;
    if (area >= 5) {
      return (75 * totalArea) / 100;
    } else {
      return (85 * totalArea) / 100;
    }
  }

  static String cityChecker(String city, num area, num selectedFloors,
      String consType, String consMode) {
    switch (city) {
      case "Islamabad":
        greyStructureCost = 2750;
        furnishingCost = 2400;
        return calculatingCost(
          city: city,
          area: area,
          selectedFloors: selectedFloors,
          consType: consType,
          consMode: consMode,
          greyCost: greyStructureCost,
          fullCost: furnishingCost,
        );
      case "Lahore":
        greyStructureCost = 2760;
        furnishingCost = 2450;
        return calculatingCost(
          city: city,
          area: area,
          selectedFloors: selectedFloors,
          consType: consType,
          consMode: consMode,
          greyCost: greyStructureCost,
          fullCost: furnishingCost,
        );
      case "Karachi":
        greyStructureCost = 2750;
        furnishingCost = 2440;
        return calculatingCost(
          city: city,
          area: area,
          selectedFloors: selectedFloors,
          consType: consType,
          consMode: consMode,
          greyCost: greyStructureCost,
          fullCost: furnishingCost,
        );
      case "Rawalpindi":
        greyStructureCost = 2650;
        furnishingCost = 2350;
        return calculatingCost(
          city: city,
          area: area,
          selectedFloors: selectedFloors,
          consType: consType,
          consMode: consMode,
          greyCost: greyStructureCost,
          fullCost: furnishingCost,
        );
      default:
        greyStructureCost = 0;
        furnishingCost = 0;
        return "Error";
    }
  }

  static String calculatingCost({
    required String city,
    required num area,
    required num selectedFloors,
    required String consType,
    required String consMode,
    required num greyCost,
    required num fullCost,
  }) {
    //only GreyStructure selected
    if (consType == "Grey Structure" &&
        consMode == "Not Selected" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost, furnCost: 0, area: area);
    }
    //only Complete Selected
    else if (consType == "Complete" &&
        consMode == "Not Selected" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost,
          furnCost: furnishingCost,
          area: area);
    }
    //only Without Material Selected
    else if (consType == "Not Selected" &&
        consMode == "Without Material" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost - 320,
          furnCost: furnishingCost,
          area: area);
    }
    //only With Material Selected
    else if (consType == "Not Selected" &&
        consMode == "With Material" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost,
          furnCost: furnishingCost,
          area: area);
    }
    //only Floors Selected
    else if (consType == "Not Selected" &&
        consMode == "Not Selected" &&
        selectedFloors != 0) {
      totalCost = (greyStructureCost + 70) * selectedFloors * area;
    }
    // GreyStructure With Material no Floor Selected
    else if (consType == "Grey Structure" &&
        consMode == "With Material" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost, furnCost: 0, area: area);
    }
    // GreyStructure Without Material no Floor Selected
    else if (consType == "Grey Structure" &&
        consMode == "Without Material" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: (greyStructureCost - 320), furnCost: 0, area: area);
    }
    // GreyStructure With Material Floor Selected
    else if (consType == "Grey Structure" &&
        consMode == "With Material" &&
        selectedFloors != 0) {
      totalCost = (greyStructureCost + 70) * selectedFloors * area;
    }
    // GreyStructure Without Material Floor Selected
    else if (consType == "Grey Structure" &&
        consMode == "Without Material" &&
        selectedFloors != 0) {
      totalCost = (greyStructureCost - 250) * selectedFloors * area;
    }
    //Complete With Material No Floor Selected
    else if (consType == "Complete" &&
        consMode == "With Material" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost,
          furnCost: furnishingCost,
          area: area);
    }
    //Complete Without Material No Floor Selected
    else if (consType == "Complete" &&
        consMode == "Without Material" &&
        selectedFloors == 2) {
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost,
          furnCost: furnishingCost - 50,
          area: area);
    }
    //Complete With Material Floor Selected
    else if (consType == "Complete" &&
        consMode == "With Material" &&
        selectedFloors != 0) {
      totalCost =
          (greyStructureCost + 70 + furnishingCost) * selectedFloors * area;
    }
    //Complete Without Material Floor Selected
    else if (consType == "Complete" &&
        consMode == "Without Material" &&
        selectedFloors != 0) {
      totalCost =
          (greyStructureCost + 70 + furnishingCost) * selectedFloors * area;
    } else {
      /*If user just select city and enter the area than this default 
        double story fully furnished cost for the entered area will 
        be calculated for that City. */
      totalCost = noExtraOptionSelected(
          greyStructCost: greyStructureCost,
          furnCost: furnishingCost,
          area: area);
    }
    finalCost = formatter.format(totalCost);
    return finalCost;
  }

  static num noExtraOptionSelected(
      {required num greyStructCost, required num furnCost, required num area}) {
    //greyStructure Cost for 1st floor.
    num fisrtFloor = (greyStructCost + 70) * area;
    //greyStructure Cost for 2nd floor.
    num secondFloor = (greyStructCost - 250) * area;
    //Furnishing Cost.
    num fCost = furnCost * 2 * coveredArea;
    return fisrtFloor + secondFloor + fCost;
  }
}
