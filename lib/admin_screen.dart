import 'package:MyPet/petOwner_main.dart';
import 'package:MyPet/view_service.dart';
import 'package:flutter/material.dart';
import 'Appointment.dart';
import 'Mypets.dart';
import 'add_dr.dart';
import 'admin_calender.dart';
import 'admin_main.dart';
import 'login.dart';
import 'ownerProfile.dart';
import 'package:MyPet/models/global.dart';

class managerPage extends StatefulWidget {
  const managerPage({Key? key}) : super(key: key);

  @override
  _managerPageState createState() => _managerPageState();
}

class _managerPageState extends State<managerPage> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),

  ];


  void changeIndex(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _globalKey = navKeys.globalKeyAdmin;
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          key: _globalKey,
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFFFF6B81),
          unselectedItemColor: Color(0xFF9db0a5),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined
              ),
              label:"Home",
              activeIcon: Icon(Icons.home
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined
              ),
              label:"Schedule",
              activeIcon: Icon(Icons.date_range
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_contact_calendar_outlined
              ),
              label:"Employees",
              activeIcon: Icon(Icons.perm_contact_calendar
              ),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.article
            //   ),
            //   label:"Service",
            //   activeIcon: Icon(Icons.article_outlined
            //   ),
            // ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
           // _buildOffstageNavigator(3),

          ],
        ),
      ),
    );
  }


  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          AdminHomePage(),
          appointCalendar(),
          docList(),
         // ServiceList(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context, index);
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {

          return MaterialPageRoute(
            builder: (context) => (routeBuilders as dynamic)[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
