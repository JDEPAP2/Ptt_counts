// import 'dart:math';

// import 'package:cuentas_ptt/utils/AppColor.dart';
// import 'package:cuentas_ptt/utils/Database.dart';
// import 'package:cuentas_ptt/views/Page_switcher.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
// import 'package:dropdown_textfield/dropdown_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:cuentas_ptt/class/Record.dart';
// import 'package:flutter/services.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongodb;

// class FilterItem extends StatefulWidget{

//   FilterItem({required this.getState, required this.list, required this.item});
//   Function getState;
//   List<Record> list;
//   Function item;
  

//   @override
//   _FilterItemState createState() => _FilterItemState(getState: getState, list: list, item: item);
// }

// class _FilterItemState extends State<FilterItem>{

//   Function getState;
//   List<Record> list;
//   Function item;
//   String value = "";
//   String date = "";

//   _FilterItemState({required this.getState, required this.list, required this.item});

//   late List People;
//   late TextEditingController dateC;
//   late TextEditingController dateC1;
//   late TextEditingController dateC2;
  

//   @override
//   void initState() {
//     dateC = TextEditingController(text: dateToString(DateTime.now()));
//     dateC1 = TextEditingController(text: dateToString(DateTime.now()));
//     dateC2 = TextEditingController(text: dateToString(DateTime.now()));
//     handlePeople();
//     super.initState();
//   }

//     TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = _format(newValue.text, '/');
//     return newValue.copyWith(text: text, selection: updateCursorPosition(text));
//   }

//   String _format(String value, String seperator) {
//     value = value.replaceAll(seperator, '');
//     var newString = '';

//     for (int i = 0; i < min(value.length, 8); i++) {
//       newString += value[i];
//       if ((i == 1 || i == 3) && i != value.length - 1) {
//         newString += seperator;
//       }
//     }

//     return newString;
//   }

//   TextSelection updateCursorPosition(String text) {
//     return TextSelection.fromPosition(TextPosition(offset: text.length));
//   }

//     DateTime stringToDate(String v){
//     List values = v.split("/");
//     try{
//       return DateTime(int.parse(values[2]),int.parse(values[1]),int.parse(values[0]));
//     }catch(err){
//       return DateTime.now();
//     }

//   }

//   String dateToString(DateTime v){
//     return "${v.day}/${v.month}/${v.year}";
//   }


//   handlePeople() async{
//     People = List.empty(growable: true);
//     List peopleDb = await Database().getPeople();
//     if (peopleDb != null){
//       peopleDb.forEach((element) {People.add(element["name"]);});
//     }
//   }



//   getValueField(){
//     TextEditingController valueController = TextEditingController(text: value);
//     valueController.selection = TextSelection.fromPosition(TextPosition(offset: valueController.text.length));

//     Widget resW = TextField(
//       controller: valueController,
//       onChanged: (v){
//         value = v;
//       },
//       keyboardType: TextInputType.number,
//       inputFormatters: [CurrencyTextInputFormatter(
//         symbol: "\$ ",
//         decimalDigits: 0,
//         enableNegative: false,
//       )],
//       style: TextStyle(color: Colors.white, fontSize: 13),
//       decoration: InputDecoration( 
//             border: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             hintText: "\$ 0",
//             labelStyle: TextStyle(color: Colors.white, fontSize: 13),
//             hintStyle: TextStyle(color: Colors.white70, fontSize: 13))
//       );

//       return {
//         "widget": resW,
//         "value": valueController.value
//       };

//   }

//   getDateField(dateController){
    
//     dateController.selection = TextSelection.fromPosition(TextPosition(offset: dateController.text.length));

//     Widget resW = TextField(
//       keyboardType: TextInputType.datetime,
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         TextInputFormatter.withFunction((oldValue, newValue) => formatEditUpdate(oldValue, newValue))],
//       onChanged: (value){
//         date = value;
//       },
//       controller: dateController,
//       style: TextStyle(color: Colors.white, fontSize: 12),
//       onTapOutside: (v) => FocusManager.instance.primaryFocus?.unfocus(),
//       decoration: InputDecoration( 
//             border: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             hintText: "dd/mm/aaaa",
//             labelStyle: TextStyle(color: Colors.white, fontSize: 12),
//             hintStyle: TextStyle(color: Colors.white70, fontSize: 12))
//       );

//       return resW;

//   }

//   dateButton(dateController){
//     final widgetD = InkWell(
//             onTap: ()async{
//               try{
//                 DateTime? date = await showDatePicker(
//                 context: context, 
//                 initialDate: stringToDate(dateController.text), 
//                 firstDate: DateTime(2000), 
//                 lastDate: DateTime.now().add(Duration(days: 15)),
//                 builder: (context, child) {
//                   return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(
//                     primary: AppColor.primary,
//                   )), child: child!);
//                 });
//                 if(date != null){
//                   setState(() {
//                     dateController.text = dateToString(date);
//                   });
//                 }
//               }catch(err){
//                 DateTime? date = await showDatePicker(
//                 context: context, 
//                 initialDate: DateTime.now(), 
//                 firstDate: DateTime(2000), 
//                 lastDate: DateTime.now().add(Duration(days: 15)),
//                 builder: (context, child) {
//                   return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(
//                     primary: AppColor.primary,
//                   )), child: child!);
//                 });
//                 if(date != null){
//                   setState(() {
//                     dateController.text = dateToString(date);
//                   });
//                 }
//               }

//               },
//             child: Container(child: Icon(Icons.date_range_rounded, size: 20, color: Colors.white), 
//             margin: EdgeInsets.only(right: 12)),
//           );
//     return widgetD;
//   }


//   Widget? handleFilter(BuildContext context, item){

//     Widget? child;
//     String title = "";
//     BoxDecoration? decoration = null;
//     int i = item();

//     switch (i){
//       case 0:
//         break;

//       case 1:
//         title = "Elija la persona de la cual se desplegara la informacion";
//         SingleValueDropDownController nameController = SingleValueDropDownController();

//         decoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//                   );

//         child = DropDownTextField(
//               dropdownColor: AppColor.dark.withOpacity(0.9),
//               textStyle: TextStyle(color: Colors.white),
//               listTextStyle: TextStyle(color: Colors.white),
//               textFieldDecoration: InputDecoration(
//                       border: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintStyle: TextStyle(color: Colors.white70),
//                       hintText: "Seleccionar Filtro"
//                     ),
//               dropDownList: handlePeopleDropDown(People), 
//               dropdownRadius: 10,
//               controller: nameController,);

//         var name = nameController.dropDownValue?.value;
//         if( name != null){
//           Map person = Database().getPersonByName(name);
//           if(person.isNotEmpty){
//             List listdb = Database().getRecordsByPerson(person["_id"], getState());
//             list = listdb.map((e){
//               return Record(id: e['_id'], nameId: e['nameId'], name: e['name'], type: e['type'], value: double.parse(e['value']), date: DateTime.parse(e['date']), observation: e['observation']);
//             }).toList();
//             print(list);
//           }
//         }

        
//         break;
        
//       case 2:
//         title = "Elija las persona de las cuales se desplegara la informacion";
//         MultiValueDropDownController namesController = MultiValueDropDownController();

//         decoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//                   );

//         child = DropDownTextField.multiSelection(
//               dropdownColor: AppColor.dark.withOpacity(0.9),
//               textStyle: TextStyle(color: Colors.white),
//               listTextStyle: TextStyle(color: Colors.white),
//               textFieldDecoration: InputDecoration(
//                       border: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintStyle: TextStyle(color: Colors.white70),
//                       hintText: "Seleccionar Filtro"
//                     ),
//               dropDownList: handlePeopleDropDown(People), 
//               dropdownRadius: 10,
//               controller: namesController,);

//         List<DropDownValueModel>? names = namesController.dropDownValueList;
//         if( names != null && names.isNotEmpty){

//             List<mongodb.ObjectId> people = names.map((e){
//             var name = e.value;
//             return mongodb.ObjectId.fromHexString(Database().getPersonByName(name)['_id']);}).toList();

//           if(people.isNotEmpty){
//             List listdb = Database().getRecordsByPeople(people, getState());
//             list = listdb.map((e){
//               return Record(id: e['_id'], nameId: e['nameId'], name: e['name'], type: e['type'], value: double.parse(e['value']), date: DateTime.parse(e['date']), observation: e['observation']);
//             }).toList();
//           }
//         }
//         break;

//       case 3:
//         final value = getDateField(dateC);
//         final date = dateButton(dateC);

//         final vDecoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//         );

//         title = "Elija la fecha por la cual se desplegara la informacion";
//         child = Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               child: Text("Desde:", style: TextStyle(fontSize: 18, color: Colors.white70)),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               padding: EdgeInsets.symmetric(horizontal: 5),
//               width: MediaQuery.of(context).size.width * 0.5,
//               decoration: vDecoration,
//               child: value,
//             ),
//             Container(
//               child: date,
//             )
//           ],
//         );

//         break;

//       case 4:
//         final value1 = getDateField(dateC1);
//         final value2 = getDateField(dateC2);
//         final date1 = dateButton(dateC1);
//         final date2 = dateButton(dateC2);

//         final vDecoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//         );

//         title = "Elija el rango de las fechas por las cuales se desplegara la informacion";
//         child = Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               child: Text("Desde:", style: TextStyle(fontSize: 14, color: Colors.white70)),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 5),
//               padding: EdgeInsets.symmetric(horizontal: 5),
//               width: MediaQuery.of(context).size.width * 0.18,
//               decoration: vDecoration,
//               child: value1,
//             ),
//             Container(
//               child: date1,
//             ),
//             Container(
//               child: Text("hasta:", style: TextStyle(fontSize: 14, color: Colors.white70)),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 5),
//               padding: EdgeInsets.symmetric(horizontal: 5),
//               width: MediaQuery.of(context).size.width * 0.18,
//               decoration: vDecoration,
//               child: value2,
//             ),
//             Container(
//               child: date2,
//             )
//           ],
//         );


//         break;
//       case 5:
//         title = "Elija el valor por el cual se desplegara la informacion";
//         decoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//                   );

//         final value = getValueField();
//         child = value['widget'];

//         break;
//       case 6:
//         final value1 = getValueField();
//         final value2 = getValueField();
//         final vDecoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//                   );
//         title = "Elija el rango de los valores por los cuales se desplegara la informacion";
//         child = Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               child: Text("Desde:", style: TextStyle(fontSize: 14, color: Colors.white70)),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               padding: EdgeInsets.symmetric(horizontal: 5),
//               width: MediaQuery.of(context).size.width * 0.25,
//               decoration: vDecoration,
//               child: value1['widget'],
//             ),
//             Container(
//               child: Text("hasta:", style: TextStyle(fontSize: 14, color: Colors.white70)),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               padding: EdgeInsets.symmetric(horizontal: 5),
//               width: MediaQuery.of(context).size.width * 0.25,
//               decoration: vDecoration,
//               child: value2['widget'],
//             ),
//           ],
//         );

//         break;
//       case 7:
//         title = "Elija el valor por el cual se desplegara la informacion con mayor a este";
//         decoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//                   );

//         final value = getValueField();
//         child = value['widget'];

//         break;
//       case 8:
//         title = "Elija el valor por el cual se desplegara la informacion con menor a este";
//         decoration = BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)
//                   );

//         final value = getValueField();
//         child = value['widget'];

//         break;
//       case 9:
//         break;
//     }

//     Widget res = child != null? Container(
//             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
//             padding: EdgeInsets.symmetric(horizontal: 2),
//             child:  Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   child: Text(title, 
//                   style: TextStyle(fontSize: 15, color: Colors.white70)),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(left: 10),
//                   decoration: decoration,
//                   width: double.maxFinite,
//                   child: child,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 )
//               ],
//             )
//             ): SizedBox(
//                   height: 10,
//                 );
      
//       return res;



//   }

//   String toFirstUpperCase(String s){
//     List<String> chars = s.split("");
//     chars[0] = chars[0].toUpperCase();
//     String res = "";
//     chars.forEach((e)=> res +=e);
//     return res;
//   }

//   List<DropDownValueModel> handlePeopleDropDown(List people) {

//       return people.map((e){
//         return DropDownValueModel(name: toFirstUpperCase(e), value: e);
//       }).toList();

//   }




//   @override
//   Widget build(BuildContext context) {
//     return handleFilter(context, item)?? SizedBox();
//   }
// }
