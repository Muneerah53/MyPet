import 'package:MyPet/petOwner_main.dart';
import 'package:flutter/material.dart';
import 'Appointment.dart';
import 'Mypets.dart';
import 'ownerProfile.dart';
import 'package:MyPet/models/global.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    //GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];


  void changeIndex(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }
  GlobalKey _globalKey = navKeys.globalKey;

  @override
  Widget build(BuildContext context) {

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
              icon: Icon(Icons.pets_outlined
              ),
              label:"Pets",
              activeIcon: Icon(Icons.pets
              ),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_today_outlined
            //   ),
            //   label:"Appointments",
            //   activeIcon: Icon(Icons.calendar_today
            //   ),
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined
              ),
              label:"Profile",
              activeIcon: Icon(Icons.person
              ),
            ),
          ],
          onTap: (index) {
             int  i = _selectedIndex;
             if(i==index){
               _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
             }
           setState(() {
             _selectedIndex = index;
           }  );


          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
           // _buildOffstageNavigator(2),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }



  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          new ownerPage(),
          new Mypets(),
         // new appointmentPage(),
          new Profile()
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
