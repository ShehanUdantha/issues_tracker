import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:issues_tracker/providers/bottom_nav_provider.dart';
import 'package:issues_tracker/providers/filter_provider.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/screens/main/home_screen.dart';
import 'package:issues_tracker/screens/main/search_screen.dart';
import 'package:issues_tracker/screens/main/profile_screen.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pageList = const [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // refresh user details and add current user details
    Provider.of<UserProvider>(context, listen: false).refreshUserDetails();
    // set back to home screen
    Provider.of<BottomNavigationProvider>(context, listen: false).setDefault();
    // clear all selected filter methods
    Provider.of<FilterProvider>(context, listen: false).setDefault();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavigationProvider, child) {
        return Scaffold(
          body: pageList[bottomNavigationProvider.pageIndex],
          bottomNavigationBar: SafeArea(
            child: BottomNavigationBar(
              currentIndex: bottomNavigationProvider.pageIndex,
              onTap: (value) {
                bottomNavigationProvider.updateIndex(value);
              },
              elevation: 2,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: AppColors.textWhite,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Iconsax.element_plus,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Iconsax.search_normal,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Iconsax.user,
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
