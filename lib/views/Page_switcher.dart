import 'package:cuentas_ptt/views/Export_View.dart';
import 'package:cuentas_ptt/views/Find_View.dart';
import 'package:cuentas_ptt/views/Home_View.dart';
import 'package:cuentas_ptt/views/People_View.dart';
import 'package:cuentas_ptt/views/screens/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:flutter_switch/flutter_switch.dart';


class PageSwitcher extends StatefulWidget {
  const PageSwitcher();
  
  @override
  _PageSwitcherState createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {

  _PageSwitcherState();

  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool rtype = false;

  @override
  void initState() {
    super.initState();
    AppColor().setColors(rtype);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    AppColor().setColors(rtype);
  }

  @override
  Widget build(BuildContext context) {
    getState(){
      return rtype;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(rtype? "Egresos":"Ingresos", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: AppColor.primary,
        leadingWidth: 100,
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: FlutterSwitch(
            activeColor: AppColor.light,
            inactiveColor: AppColor.light,
            value: rtype, 
            onToggle: (v){
        setState(() {
          rtype = v;
        });
      }),
        )
      ),
      
      extendBody: true,
      body: Stack(
        children: [
          [HomeView(getState: getState), FindView(getState: getState), PeopleView(getState: getState), ExportView(getState: getState)][_selectedIndex],
          BottomGradientWidget(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
    );
  }
}

class BottomGradientWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          gradient: AppColor.navGradient))
    );
  }
}
