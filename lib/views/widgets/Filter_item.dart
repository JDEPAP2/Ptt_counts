import 'dart:math';

import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/utils/PeopleController.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongodb;

class FilterItem extends StatefulWidget{

  FilterItem({required this.getState, required this.list, required this.item, required this.setList});
  Function getState, setList;
  List<Record> list;
  Function item;
  

  @override
  _FilterItemState createState() => _FilterItemState(getState: getState, list: list, item: item, setList: setList);
}

class _FilterItemState extends State<FilterItem>{

  Function getState, setList;
  List<Record> list;
  Function item;
  String value = "";
  String date = "";

  _FilterItemState({required this.getState, required this.list, required this.item, required this.setList});

  late List<Person> people;
  late SingleValueDropDownController nameController;
  late MultiValueDropDownController namesController;
  late TextEditingController dateC;
  late TextEditingController dateC1;
  late TextEditingController dateC2;
  late TextEditingController valC;
  late TextEditingController valRanC1;
  late TextEditingController valRanC2;
  late String param;
  dynamic element;
  

  @override
  void initState() {
    param = "null";
    dateC = TextEditingController(text: FormatDate.dateToString(DateTime.now()));
    dateC1 = TextEditingController(text: FormatDate.dateToString(DateTime.now()));
    dateC2 = TextEditingController(text: FormatDate.dateToString(DateTime.now()));
    valC = TextEditingController(text: "\$0");
    valRanC1 = TextEditingController(text: "\$0");
    valRanC2 = TextEditingController(text: "\$0");
    nameController = SingleValueDropDownController();
    namesController = MultiValueDropDownController();
    people = List.empty(growable: true);
    handlepeople();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if(element != null){
      handleAsync();
    }
  }

  handleAsync() async{
    list.clear();
    await handleParam();
    setList(list);
    print("Tamano: ${list.length}");
  }

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '/');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, 8); i++) {
      newString += value[i];
      if ((i == 1 || i == 3) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }



  handlepeople() async{
    people = await PeopleController.getPeople()??[];
    setState(() {
    });
  }

  handleParam() async{
    list.clear;
    List<Record> auxList = await RecordsController.getRecordsBy(param, element, getState())??[];
    if(auxList.isNotEmpty){
      list = auxList;
    }
    
  }

  getValueField(TextEditingController controller){
    TextEditingController valueController = controller;
    valueController.selection = TextSelection.fromPosition(TextPosition(offset: valueController.text.length));

    Widget resW = TextField(
      controller: valueController,
      onChanged: (v){
        value = v;
        if (param == "valueRange") {
          element = [FormatValue.StringToFormatDouble(valRanC1.text), FormatValue.StringToFormatDouble(valRanC2.text)];
        } else {
          element = FormatValue.StringToFormatDouble(valC.text);
        }
        setState(() { });
      },
      keyboardType: TextInputType.number,
      inputFormatters: [CurrencyTextInputFormatter(
        symbol: "\$ ",
        decimalDigits: 0,
        enableNegative: false,
      )],
      style: TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration( 
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "\$ 0",
            labelStyle: TextStyle(color: Colors.white, fontSize: 13),
            hintStyle: TextStyle(color: Colors.white70, fontSize: 13))
      );

      return {
        "widget": resW,
        "value": valueController.value
      };

  }

  getDateField(dateController){
    
    dateController.selection = TextSelection.fromPosition(TextPosition(offset: dateController.text.length));

    Widget resW = TextField(
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) => formatEditUpdate(oldValue, newValue))],
      onChanged: (value){
        date = value;
      },
      controller: dateController,
      style: TextStyle(color: Colors.white, fontSize: 12),
      onTapOutside: (v) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration( 
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "dd/mm/aaaa",
            labelStyle: TextStyle(color: Colors.white, fontSize: 12),
            hintStyle: TextStyle(color: Colors.white70, fontSize: 12))
      );

      return resW;

  }

  dateButton(dateController){
    final widgetD = InkWell(
            onTap: ()async{
              try{
                DateTime? date = await showDatePicker(
                context: context, 
                initialDate: FormatDate.stringToDate(dateController.text), 
                firstDate: DateTime(2000), 
                lastDate: DateTime.now().add(Duration(days: 15)),
                builder: (context, child) {
                  return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(
                    primary: AppColor.primary,
                  )), child: child!);
                });
                if(date != null){
                  setState(() {
                    dateController.text = FormatDate.dateToString(date);
                  });
                  if(param == "date"){
                    element = FormatDate.stringToDate(dateC.text); 
                  }else if(param == "dateRange"){
                    print(dateC1.text);
                    print(dateC2.text);
                    element = [FormatDate.stringToDate(dateC1.text),FormatDate.stringToDate(dateC2.text)]; 
                  }
                  setState(() {});
                }
              }catch(err){
                DateTime? date = await showDatePicker(
                context: context, 
                initialDate: DateTime.now(), 
                firstDate: DateTime(2000), 
                lastDate: DateTime.now().add(Duration(days: 15)),
                builder: (context, child) {
                  return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(
                    primary: AppColor.primary,
                  )), child: child!);
                });
                if(date != null){
                  setState(() {
                    dateController.text = FormatDate.dateToString(date);
                    param = "date";
                    element = FormatDate.stringToDate(dateController.text);
                  });
                  
                }
              }

              },
            child: Container(child: Icon(Icons.date_range_rounded, size: 20, color: Colors.white), 
            margin: EdgeInsets.only(right: 12)),
          );
    return widgetD;
  }


  Widget? handleFilter(BuildContext context, item){

    Widget? child;
    String title = "";
    BoxDecoration? decoration = null;
    int i = item;

    print("entro, item:$item");

    switch (i){
      case 0:
        break;

      case 1:
        title = "Elija la persona de la cual se desplegara la informacion";
        decoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  );

        child = DropDownTextField(
              dropdownColor: AppColor.dark.withOpacity(0.9),
              textStyle: TextStyle(color: Colors.white),
              listTextStyle: TextStyle(color: Colors.white),
              textFieldDecoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white70),
                      hintText: "Seleccionar Filtro"
                    ),
              dropDownList: handlepeopleDropDown(people), 
              dropdownRadius: 10,
              onChanged: (value) async{
                list.clear();
                if(value != null){
                  setState(() {
                    param = "person";
                    element = nameController.dropDownValue?.value??"";
                  });
                }
              },
              controller: nameController,);        
        break;
        
      case 2:
        title = "Elija las persona de las cuales se desplegara la informacion";

        decoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  );

        child = DropDownTextField.multiSelection(
              dropdownColor: AppColor.dark.withOpacity(0.9),
              textStyle: TextStyle(color: Colors.white),
              listTextStyle: TextStyle(color: Colors.white),
              textFieldDecoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white70),
                      hintText: "Seleccionar Filtro"
                    ),
              onChanged: (value) async {
                list.clear();
                if(value != null){
                  if(namesController.dropDownValueList != null){
                    setState(() {
                      param = "people";
                      element = namesController.dropDownValueList?.map((e) => e.value??"").toList().cast<String>()??[];
                    });
                  }
                }
              },
              dropDownList: handlepeopleDropDown(people), 
              dropdownRadius: 10,
              controller: namesController);
        break;

      case 3:
        setState(() {
          param = "date";
          element = null;
        });

        dateC = TextEditingController(text: FormatDate.dateToString(DateTime.now()));
        final value = getDateField(dateC);
        final date = dateButton(dateC);

        final vDecoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
        );

        title = "Elija la fecha por la cual se desplegara la informacion";
        child = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text("Desde:", style: TextStyle(fontSize: 18, color: Colors.white70)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: vDecoration,
              child: value,
            ),
            Container(
              child: date,
            )
          ],
        );
        break;

      case 4:
        setState(() {
          param = "dateRange";
          element = null;
        });
            
        dateC1 = TextEditingController(text: FormatDate.dateToString(DateTime.now()));
        dateC2 = TextEditingController(text: FormatDate.dateToString(DateTime.now()));
        final value1 = getDateField(dateC1);
        final value2 = getDateField(dateC2);
        final date1 = dateButton(dateC1);
        final date2 = dateButton(dateC2);

        final vDecoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
        );

        title = "Elija el rango de las fechas por las cuales se desplegara la informacion";
        child = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text("Desde:", style: TextStyle(fontSize: 14, color: Colors.white70)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width * 0.18,
              decoration: vDecoration,
              child: value1,
            ),
            Container(
              child: date1,
            ),
            Container(
              child: Text("hasta:", style: TextStyle(fontSize: 14, color: Colors.white70)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width * 0.18,
              decoration: vDecoration,
              child: value2,
            ),
            Container(
              child: date2,
            )
          ],
        );
        break;

      case 5:
        setState(() {
          param = "value";
          element = null;
        });
        title = "Elija el valor por el cual se desplegara la informacion";
        decoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  );

        final value = getValueField(valC);
        child = value['widget'];
        break;

      case 6:
      setState(() {
          param = "valueRange";
          element = null;
        });
        final value1 = getValueField(valRanC1);
        final value2 = getValueField(valRanC2);
        final vDecoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  );
        title = "Elija el rango de los valores por los cuales se desplegara la informacion";
        child = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text("Desde:", style: TextStyle(fontSize: 14, color: Colors.white70)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: vDecoration,
              child: value1['widget'],
            ),
            Container(
              child: Text("hasta:", style: TextStyle(fontSize: 14, color: Colors.white70)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: vDecoration,
              child: value2['widget'],
            ),
          ],
        );

        break;
      case 7:
        setState(() {
            param = "valueGt";
            element = null;
          });
        title = "Elija el valor por el cual se desplegara la informacion con mayor a este";
        decoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  );

        final value = getValueField(valC);
        child = value['widget'];

        break;
      case 8:
        setState(() {
            param = "valueLt";
            element = null;
          });
        title = "Elija el valor por el cual se desplegara la informacion con menor a este";
        decoration = BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  );

        final value = getValueField(valC);
        child = value['widget'];

        break;
      case 9:
        setState(() {
          param = "null";
          element = "";
        });
        break;
    }

    Widget res = child != null? Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            padding: EdgeInsets.symmetric(horizontal: 2),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(title, 
                  style: TextStyle(fontSize: 15, color: Colors.white70)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: decoration,
                  width: double.maxFinite,
                  child: child,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            )
            ): SizedBox(
                  height: 10,
                );
      
      setState(() {
        
      });
      return res;



  }

  String toFirstUpperCase(String s){
    List<String> chars = s.split("");
    chars[0] = chars[0].toUpperCase();
    String res = "";
    chars.forEach((e)=> res +=e);
    return res;
  }

  List<DropDownValueModel> handlepeopleDropDown(List people) {
      return people.map((e){
        return DropDownValueModel(name: toFirstUpperCase(e.user), value: e.user);
      }).toList();

  }




  @override
  Widget build(BuildContext context) {
    print("pasa");
    return handleFilter(context, item())?? SizedBox(height: 100,);
  }
}
