import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:flutter/material.dart';

class RecordItem extends StatefulWidget{
  Function getState;
  RecordItem({required this.getState});

  @override
  _RecordItemState createState() => _RecordItemState(getState: getState);
}

class _RecordItemState extends State<RecordItem>{

  Function getState;
  _RecordItemState({required this.getState});

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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text("10/10/2021",
              style: TextStyle(color: AppColor.light.withOpacity(0.8),
                  fontSize: 19)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Row(
                children: [
                  Container(
                    child: Text("Niche",
                    style: TextStyle(fontSize: 28,
                    color: AppColor.black)),
                  ),
                  Spacer(),
                  Container(
                    child: Icon(rtype?Icons.remove_rounded:Icons.add_rounded, color: AppColor.primary,),
                  ),
                  Container(
                    child: Text("\$100.000",
                    style: TextStyle(fontSize: 20,
                    color: AppColor.dark)),
                  ),
                ]
                ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Text("Esta es una observacion", 
                style: TextStyle(color: AppColor.dark.withOpacity(0.5))),
              )
            )
          ]
          ),
      )
    );}
}