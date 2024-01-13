import 'package:anima/constraint.dart';
import 'package:flutter/material.dart';

ThemeData theme(BuildContext context) {
  return ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: kBackgroundColor,
    primaryColor: kPrimaryColor,
    primarySwatch: Colors.blue,
    fontFamily: "Inter",
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
    ),
    textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          fontFamily: "Inter",
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackgroundColor,
      titleTextStyle: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      toolbarHeight: 70,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
      labelStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      padding: const EdgeInsets.all(10),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: kActionColor,
      circularTrackColor: kBackgroundColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      iconColor: Colors.white,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    ),
    indicatorColor: kActionColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: kBackgroundColor,
      selectedItemColor: kActionColor,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    radioTheme: const RadioThemeData(
      fillColor: MaterialStatePropertyAll(kActionColor),
    ),
  );
}
