import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:flutter/material.dart';

class RecordItem extends StatefulWidget{
  Function getState;
  Record record;
  RecordItem({required this.getState, required this.record});

  @override
  _RecordItemState createState() => _RecordItemState(getState: getState, record:record);
}

class _RecordItemState extends State<RecordItem>{

  Function getState;
  Record record;
  _RecordItemState({required this.getState, required this.record});

      @override
  Widget build(BuildContext context) {
    bool rtype = getState();
    return InkWell(
      splashColor: AppColor.light,
      onTap: () => {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(FormatDate.dateToString(record.date),
              style: TextStyle(color: AppColor.light.withOpacity(0.8),
                  fontSize: 18)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Row(
                children: [
                  Container(
                    child: Text(record.name,
                    style: TextStyle(fontSize: 22,
                    color: AppColor.white, fontWeight: FontWeight.bold)),
                  ),
                  Spacer(),
                  Container(
                    child: Icon(rtype?Icons.remove_rounded:Icons.add_rounded, color: AppColor.light.withAlpha(150),),
                  ),
                  Container(
                    child: Text("\$${FormatValue.doubleToString(record.value)}",
                    style: TextStyle(fontSize: 20,
                    color: AppColor.white.withOpacity(0.8))),
                  ),
                ]
                ),
            ),
            record.observation != ""? Container(
              padding: EdgeInsets.all(8),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColor.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Text(record.observation??"", 
                style: TextStyle(color: AppColor.white.withOpacity(0.5))),
              )
            ):Container(height: 10)
          ]
          ),
      )
    );}
}