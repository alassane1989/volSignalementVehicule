import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Auth
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// Citizen
import 'screens/citizen/citizen_home_screen.dart';
import 'screens/citizen/add_moto_screen.dart';
import 'screens/citizen/my_motos_screen.dart';
import 'screens/citizen/edit_moto_screen.dart';

import 'screens/citizen/create_report_screen.dart';
import 'screens/citizen/my_reports_screen.dart';
import 'screens/citizen/report_detail_screen.dart';
import 'screens/citizen/edit_report_screen.dart';
import 'screens/citizen/edit_profile_screen.dart';

// Police
import 'screens/police/police_home_screen.dart';
import 'screens/police/police_login_screen.dart';
import 'screens/police/police_dashboard_screen.dart';
import 'screens/police/plate_check_screen.dart';
import 'screens/police/police_report_detail_screen.dart';
import 'screens/police/verify_plate_screen.dart';
import 'screens/police/verification_history_screen.dart';
import 'screens/police/scan_plate_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/': (context) => OnboardingScreen(),

        // ✅ Citizen
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/citizenHome': (context) => CitizenHomeScreen(),
'/editProfile': (context) => EditProfileScreen(),

        '/addMoto': (context) => AddMotoScreen(),
        '/myMotos': (context) => MyMotosScreen(),
      //  '/editMoto': (context) => EditMotoScreen(moto: ModalRoute.of(context)!.settings.arguments),

        '/createReport': (context) => CreateReportScreen(),
        '/myReports': (context) => MyReportsScreen(),
        // ReportDetailScreen et EditReportScreen utilisent MaterialPageRoute → pas dans routes

        // Citoyen invité
     // '/guestReport': (context) => GuestReportScreen(),


        // ✅ Police
        '/policeHome': (context) => PoliceHomeScreen(),
        '/policeLogin': (context) => PoliceLoginScreen(),
        '/policeDashboard': (context) => PoliceDashboardScreen(),
        '/plateCheck': (context) => PlateCheckScreen(),
        '/policeReportDetail': (context) => PoliceReportDetailScreen(),
        '/verifyPlate': (context) => VerifyPlateScreen(),
        '/verificationHistory': (context) => VerificationHistoryScreen(),
        '/scanPlate': (context) => ScanPlateScreen(),
      },

      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0A1A2F),
        scaffoldBackgroundColor: Color(0xFF0F1E33),

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0A1A2F),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E3A5F),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
