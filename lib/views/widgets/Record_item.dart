import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/views/widgets/modals/Info_Record.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';

class RecordItem extends StatefulWidget{
  Function getState;
  Record record;
  Future<void> Function()? update;
  RecordItem({required this.getState, required this.record, this.update});

  @override
  _RecordItemState createState() => _RecordItemState(getState: getState, record:record, update: update);
}

class _RecordItemState extends State<RecordItem> with TickerProviderStateMixin{

  Function getState;
  Record record;
  Future<void> Function()? update;
  _RecordItemState({required this.getState, required this.record, this.update});

  late AnimationController controller;

  @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);;
  }

  Future<dynamic> handleModal(Widget modal, BuildContext context) async{
    return await showModalBottomSheet(
      transitionAnimationController: controller,
      backgroundColor: Colors.transparent,
      context: context, 
      isScrollControlled: true,
      builder: (builder) => modal);
  }

      @override
  Widget build(BuildContext context) {
    bool rtype = getState();

    handleProgress(Future<dynamic> function) async{
        showDialog(context: context, 
          builder: (context){
          return Center(child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(AppColor.secondary),
            strokeWidth: 10,
          ));
        });
        var res = await function;
        Navigator.of(context).pop();
        return res;
    }

    return InkWell(
      splashColor: AppColor.light,
      onTap: () async{
        await handleModal(InfoRecord(record: record),context);
        try {
          await handleProgress(Future.delayed(Duration(milliseconds: 1000)));
          update!();
          getState(upd:true);
        } catch (e) {
          
        }
      },
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
                  fontSize: 15)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Row(
                children: [
                  Container(
                    child: Text(FormatText.toFirstUpperCase(record.name),
                    style: TextStyle(fontSize: 21,
                    color: AppColor.white, fontWeight: FontWeight.bold)),
                  ),
                  Spacer(),
                  Container(
                    child: Icon(rtype?Icons.remove_rounded:Icons.add_rounded, color: AppColor.light.withAlpha(150),),
                  ),
                  Container(
                    child: Row(children: [
                      Text("\$",
                    style: TextStyle(fontSize: 18,
                    color: AppColor.white.withOpacity(0.8))),
                      Text(FormatValue.doubleToString(record.value),
                    style: TextStyle(fontSize: 18,
                    color: AppColor.white.withOpacity(0.8))),])
                  ),
                ]
                ),
            ),
            record.observation != "" && record.observation != null? Container(
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