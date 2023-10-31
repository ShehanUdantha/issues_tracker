import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:issues_tracker/firebase_options.dart';
import 'package:issues_tracker/providers/bottom_nav_provider.dart';
import 'package:issues_tracker/providers/filter_provider.dart';
import 'package:issues_tracker/providers/network_provider.dart';
import 'package:issues_tracker/providers/status_provider.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/screens/auth/forget_password_screen.dart';
import 'package:issues_tracker/screens/auth/signin_screen.dart';
import 'package:issues_tracker/screens/auth/signup_screen.dart';
import 'package:issues_tracker/screens/main_screen.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/theme/all_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NetworkProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Issues Tracker',
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => const SignInScreen(),
          '/register': (context) => const SignUpScreen(),
          '/forget': (context) => const ForgetPasswordScreen(),
          '/home': (context) => const MainScreen(),
        },
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          disabledColor: AppColors.grey,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: AllTheme.appAppBarTheme,
          textTheme: AllTheme.appTextTheme,
          inputDecorationTheme: AllTheme.appInputDecorationTheme,
          elevatedButtonTheme: AllTheme.appElevatedButtonTheme,
          outlinedButtonTheme: AllTheme.appOutlinedButtonTheme,
          checkboxTheme: AllTheme.appCheckboxTheme,
          bottomSheetTheme: AllTheme.appBottomSheetTheme,
        ),
        home: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: ((context, snapshot) {
            // if process pending
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: AppColors.primary,
              );
            }

            // if already logged
            if (snapshot.connectionState == ConnectionState.active) {
              // if data available
              if (snapshot.hasData) {
                return const MainScreen();
              } else if (snapshot.hasError) {
                // if no data
                return Center(
                  child: Text(
                    '${snapshot.error}',
                  ),
                );
              }
            }

            // if not login yet
            return const SignInScreen();
          }),
        ),
      ),
    );
  }
}
