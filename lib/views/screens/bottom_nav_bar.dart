import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  int selectedIndex;
  Function onItemTapped;
  CustomBottomNavigationBar(
      {required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 60, right: 60, bottom: 20),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            currentIndex: widget.selectedIndex,
            onTap: (i) => widget.onItemTapped(i),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              (widget.selectedIndex == 0)
                  ? BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded,
                          color: AppColor.dark, size: 35),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined,
                          color: Colors.grey[600], size: 30),
                      label: ''),
              (widget.selectedIndex == 1)
                  ? BottomNavigationBarItem(
                      icon: Icon(Icons.find_in_page,
                          color: AppColor.dark, size: 35),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: Icon(Icons.find_in_page_outlined,
                          color: Colors.grey[600], size: 30),
                      label: ''),
              (widget.selectedIndex == 2)
                  ? BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle_rounded,
                          color: AppColor.dark, size: 35),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle_outlined,
                          color: Colors.grey[600], size: 30),
                      label: ''),
              (widget.selectedIndex == 3)
                  ? BottomNavigationBarItem(
                      icon: Icon(Icons.upload_file_rounded,
                          color: AppColor.dark, size: 35),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: Icon(Icons.upload_file_outlined,
                          color: Colors.grey[600], size: 30),
                      label: ''),
            ],
          ),
        ),
      ),
    );
  }
}