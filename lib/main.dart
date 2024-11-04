import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/to_do_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple, // Consistent theme
        scaffoldBackgroundColor: Colors.deepPurple, // Lighter background
        textTheme: GoogleFonts.poppinsTextTheme(), // Custom Font
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
      ),
      home: const ToDoList(),
    );
  }
}
