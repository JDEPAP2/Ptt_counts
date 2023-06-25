import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:flutter/material.dart';

class PersonItem extends StatefulWidget{
  Function getState;
  PersonItem({required this.getState});

  @override
  _PersonItemState createState() => _PersonItemState(getState: getState);
}

class _PersonItemState extends State<PersonItem>{

  Function getState;
  _PersonItemState({required this.getState});

      @override
  Widget build(BuildContext context) {
    bool rtype = getState();
    return InkWell(
      splashColor: AppColor.light,
      onTap: () => {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
                    padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: Text("Niche",
                    style: TextStyle(fontSize: 22,
                    color: AppColor.black)),
                  ),
            Container(
              padding: EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  children: [
                    Text("Numero de " + (!rtype? "ingresos": "egresos") + " registrados:", 
                    style: TextStyle(color: AppColor.dark.withOpacity(0.7))),
                    Text("1", 
                    style: TextStyle(color: AppColor.dark.withOpacity(0.8))),
                  ],
                ),
              )
            )
          ]
          ),
      )
    );}
}