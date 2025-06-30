import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Screens and Forms
import 'package:farmeragriapp/screens/forms/farmer/add_expense.dart';
import 'package:farmeragriapp/screens/forms/farmer/commiunityIScreen.dart';
import 'package:farmeragriapp/screens/forms/farmer/financialIScreen.dart';
import 'package:farmeragriapp/screens/forms/farmer/generalIScreen.dart';
import 'package:farmeragriapp/screens/forms/farmer/technicalIScreen.dart';
import 'package:farmeragriapp/screens/forms/farmer/technical_inq_crud.dart';
import 'package:farmeragriapp/screens/forms/farmer/update_farmer_screen.dart';
import 'package:farmeragriapp/screens/forms/marketingOfficer/createFarmer.dart';
import 'package:farmeragriapp/screens/views/farmer/Cultivational_expense.dart';
import 'package:farmeragriapp/screens/views/buyer/browse_products.dart';
import 'package:farmeragriapp/screens/views/buyer/buyerDashboard.dart';
import 'package:farmeragriapp/screens/views/farmer/crop_details_screen.dart';
import 'package:farmeragriapp/screens/views/farmer/cultivation_screen.dart';
import 'package:farmeragriapp/screens/forms/farmer/addCultivational.dart';
import 'package:farmeragriapp/screens/views/farmer/inquiries_screen.dart';
import 'package:farmeragriapp/screens/forms/farmer/newUpdateForm.dart';
import 'package:farmeragriapp/screens/views/farmer/predictionscreen.dart';
import 'package:farmeragriapp/screens/forms/signIn_screen.dart';
import 'package:farmeragriapp/screens/forms/signUp_screen.dart';
import 'package:farmeragriapp/screens/views/farmer/splash_screen.dart';
import 'package:farmeragriapp/screens/views/marketingOfficer/add_soilReport.dart';
import 'package:farmeragriapp/screens/views/marketingOfficer/manageFarmersScreen.dart';
import 'package:farmeragriapp/screens/views/marketingOfficer/officerDashboard.dart';
import 'package:farmeragriapp/screens/views/marketingOfficer/officer_profile.dart';
import 'package:farmeragriapp/screens/views/buyer/buyer_profile.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Suppress MirrorManager warning
  SystemChannels.skia.invokeMethod('Skia.setAllowOpenGL', true);
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'),Locale('si'),Locale('ta'),],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.green),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/signIn": (context) => const SignInScreen(),
        "/signUp": (context) => const SignupScreen(),
        "/cultivational": (context) => const CultivationalScreen(),
        "/crop_updates": (context) => const CropDetailsScreen(),
        "/expenses": (context) => const CultivationalExpense(),
        "/inqueries": (context) => const InqueriesScreen(),
        "/prediction": (context) => const Predictionscreen(),
        "/addCultivational": (context) => const CultivationalAddScreen(),
        "/newcropupdate": (context) => const NewUpdateForm(),
        "/addExpenses": (context) => const AddExpense(),
        "/general": (context) => const GeneralIScreen(),
        "/commiunity": (context) => const CommiunityIscreen(),
        "/finacial": (context) => const FinancialIscreen(),
        "/technical": (context) => const TechnicalIScreen(),
        "/myTechnical": (context) => const TechnicalInquiryList(
            baseUrl: 'http://192.168.8.125:5000/api'),
        '/buyerDashboard': (context) => BuyerDashboard(),
        '/buyer_profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          return BuyerProfileScreen(
            userId: args?['userId'] ?? '',
            userType: args?['userType'] ?? 'Buyer',
          );
        },
        '/browse_products': (context) => const BrowseProductsScreen(),
        '/officerDashboard': (context) => OfficerDashboard(
              userId: '',
            ),
        '/createFarmer': (context) => const CreateFarmerScreen(),
        "/updateFarmer": (context) => const UpdateFarmerScreen(),
        "/uploadSoilTestReport": (context) => UploadSoilTestReportScreen(
              farmerId: '',
            ),
        "/manageFarmers": (context) => ManageFarmersScreen(),
        "/officerProfile": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          return OfficerProfileScreen(
            userId: args?['userId'] ?? '',
            userType: args?['userType'] ?? 'Marketing Officer',
          );
        },
      },
    );
  }
}
