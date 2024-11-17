// ignore_for_file: file_names, avoid_print, unused_element

import 'package:intl/intl.dart';

class CostCalculator {
  static num floors = 0;
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

//This cost is for double story fully furnished house.
  static String calculatingCost({required String city, required num area}) {
    checkingAreaUnit(area: area);
    if (city == "Islamabad") {
      greyStructureCost = 2000;
      furnishingCost = 2402;
      totalCost = (greyStructureCost + furnishingCost) * 2 * coveredArea;
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else if (city == "Lahore") {
      greyStructureCost = 2000;
      furnishingCost = 2452;
      totalCost = (greyStructureCost + furnishingCost) * 2 * coveredArea;
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else if (city == "Karachi") {
      greyStructureCost = 250;
      furnishingCost = 320;
      totalCost = (greyStructureCost + furnishingCost) * 2 * coveredArea;
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else if (city == "Rawalpindi") {
      greyStructureCost = 1800;
      furnishingCost = 2150;
      totalCost = (greyStructureCost + furnishingCost) * 2 * coveredArea;
      finalCost = formatter.format(totalCost);
      return finalCost;
    } else {
      print("Error: City Not Recognized");
      return 'Error';
    }
  }
}
