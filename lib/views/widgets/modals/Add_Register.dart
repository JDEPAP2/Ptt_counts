import 'dart:math';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/views/widgets/modals/Find_Person.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/utils/PeopleController.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/services.dart';
import 'package:objectid/objectid.dart';
import 'package:quickalert/quickalert.dart';


class AddRegister extends StatefulWidget{
  @override
  _AddRegisterState createState() => _AddRegisterState();
}

class _AddRegisterState extends State<AddRegister> with TickerProviderStateMixin{

  List People = List.empty(growable: true);

  late String fecha;
  late String value;
  late String obser;
  late String name;
  late bool? typeR;

    late AnimationController controller;

  @override
  void initState() {
    // db = Database();
    transitionAnimationController: controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);
    fecha = FormatDate.dateToString(DateTime.now());
    value = "";
    obser = "";
    name = "";
    typeR = null;
    // handlePeople();
    super.initState();
  }

  handlePerson(String name) async{
    if (!(await PeopleController.existPerson(name))){
      bool? res = await PeopleController.addPerson(name);
      if(res != true){
        print(res);
        return null;
      }
    }
    return (await PeopleController.findPersonByName(name))?.id;
  }


      @override
  Widget build(BuildContext context) {
    SingleValueDropDownController typeController = SingleValueDropDownController(data: typeR!=null? DropDownValueModel(name: typeR==true? "entrada":"salida", value: typeR):null );
    TextEditingController nameFieldController = TextEditingController(text: name);
    TextEditingController dateController = TextEditingController(text: fecha);
    dateController.selection = TextSelection.fromPosition(TextPosition(offset: dateController.text.length));
    TextEditingController valueController = TextEditingController(text: value);
    valueController.selection = TextSelection.fromPosition(TextPosition(offset: valueController.text.length));
    TextEditingController obserController = TextEditingController(text: obser);
    obserController.selection = TextSelection.fromPosition(TextPosition(offset: obserController.text.length));
    
    handleProgress(Future<dynamic> function) async{
        showDialog(context: context, 
          builder: (context){
          return Center(child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(Colors.green),
            strokeWidth: 10,
          ));
        });
        var res = await function;
        Navigator.of(context).pop();
        return res;
      }


    DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
    }

    _getDslDecoration() {
      return BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(width: 1, color: Colors.black12),
          top: BorderSide(width: 1, color: Colors.black12),
        ),
      );}


    final dsl = DirectSelectList<String>(
      values: ["A","B"],
      defaultItemIndex: 0,
      itemBuilder: (String value) => getDropDownMenuItem(value),
      focusedItemDecoration: _getDslDecoration(),
      onItemSelectedListener: (item, index, context) {
        
        });

    List<DropDownValueModel> handlePeopleDropDown(List people) {

      return people.map((e){
        return DropDownValueModel(name: FormatText.toFirstUpperCase(e), value: e);
      }).toList();

    }

    handleModal(Widget modal, BuildContext context) async{
        return await showModalBottomSheet(
          transitionAnimationController: controller,
          backgroundColor: Colors.transparent,
          context: context, 
          isScrollControlled: true,
          builder: (builder) => modal);
      }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      height: MediaQuery.of(context).viewInsets.bottom == 0? MediaQuery.of(context).size.height * 0.8: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text("Fecha *", style: TextStyle(fontSize: 18))),
          Row(
            children: [
              Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.only(left: 20, right: 5 ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                  width: 90,
                  child: TextField(
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) => FormatDate.formatEditUpdate(oldValue, newValue))],
                  onChanged: (value){
                    fecha = value;
                  },
                  controller: dateController,
                  onTapOutside: (v) => FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecoration( 
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "dd/mm/aaaa",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                        labelStyle: TextStyle(fontSize: 15)),
                  )
                )),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: ()async{
                      try{
                        DateTime? date = await showDatePicker(
                        context: context, 
                        initialDate: FormatDate.stringToDate(fecha), 
                        firstDate: DateTime(2000), 
                        lastDate: DateTime.now().add(Duration(days: 15)),
                        builder: (context, child) {
                          return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(
                            primary: Colors.black,
                          )), child: child!);
                        });
                        if(date != null){
                          setState(() {
                            fecha = FormatDate.dateToString(date);
                          });
                        }
                      }catch(err){
                        DateTime? date = await showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(2000), 
                        lastDate: DateTime.now().add(Duration(days: 15)),
                        builder: (context, child) {
                          return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(
                            primary: Colors.black,
                          )), child: child!);
                        });
                        if(date != null){
                          setState(() {
                            fecha = FormatDate.dateToString(date);
                          });
                        }
                      }

                      },
                    child: Icon(Icons.date_range_rounded, size: 30),
                  ),
                )
            ],
          ),
          
              ],
            ),
            Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text("Valor *", style: TextStyle(fontSize: 18))),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                  width: 115,
                  child: TextField(
                  controller: valueController,
                  onChanged: (v){
                    value = v;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyTextInputFormatter(
                    symbol: "\$ ",
                    decimalDigits: 0,
                    enableNegative: false,
                  )],
                  decoration: InputDecoration( 
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "\$ 0",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                        labelStyle: TextStyle(fontSize: 15)),
                  )
                )),      
           
              ],
            ) 
          ]),
          
          ),
          
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text("Tipo *", style: TextStyle(fontSize: 18))),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropDownTextField(
              dropDownList: [DropDownValueModel(name: "Entrada", value: true), DropDownValueModel(name: "Salida", value: false)], 
              dropdownRadius: 10,
              onChanged: (v){
                if( v is String){
                  typeR = null;
                }else{
                  typeR = v.value;
                }
              },
              controller: typeController,
              dropdownColor: Color.fromARGB(255, 233, 233, 233),
              textFieldDecoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "Seleccionar",
                    hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                    labelStyle: TextStyle(fontSize: 15)),
              )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text("Nombre *", style: TextStyle(fontSize: 18))),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
                  readOnly: true,
                  controller: nameFieldController,
                  onTap: () async{
                    dynamic modalName = await handleModal(FindPerson(controller: nameFieldController), context);
                    if(modalName is String){
                      name = modalName;
                      nameFieldController.text = modalName;
                    }
                    setState(() {
                    });
                  },
                  decoration: InputDecoration( 
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "Nombre",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                        labelStyle: TextStyle(fontSize: 15)),
                  )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text("Observación", style: TextStyle(fontSize: 18))),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                  height: 100,
                  child: TextField(
                  controller: obserController,
                  onChanged: (v) {
                    obser = v;
                  },
                  maxLength: 120,
                  maxLines: 3,
                  decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "Escribe una observacion",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                        labelStyle: TextStyle(fontSize: 15),
                        counterStyle: TextStyle(fontSize: 8)),
                  )
                )),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Cancelar", style: TextStyle(color: Colors.black87,fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.15) )
                ),
              ),
              InkWell(
                onTap: () async{
                  if(typeR==null || fecha == "" || value == "" || name == ""){
                    QuickAlert.show(
                      context: context, 
                      type: QuickAlertType.error,
                      text: "No deje los campos obligatorios vacios");
                  }else{

                    var personId = await handleProgress(handlePerson(name.toLowerCase()));
                    if(personId != null){
                      value = value.replaceAll(",", "").replaceAll("\$", "");
                      Record newRecord = Record(id: ObjectId(), nameId: personId, name: name, type:typeR, value: double.parse(value), date: FormatDate.stringToDate(fecha), observation: obser);
                        var res = await RecordsController.addRecord(newRecord);
                        if(res == true){
                          QuickAlert.show(
                            context: context, 
                            type: QuickAlertType.success,
                            text: "Registro añadido",
                            onCancelBtnTap: (){Navigator.of(context).pop();Navigator.of(context).pop();},
                            onConfirmBtnTap: (){Navigator.of(context).pop();Navigator.of(context).pop();});
                          return;
                        }
                    }
                    QuickAlert.show(
                      context: context, 
                      type: QuickAlertType.warning,
                      text: "Ocurrio un problema añadiendo los datos, intenta mas tarde");
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Añadir", style: TextStyle(color: Colors.black87,fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              )
            ]),
          )
        ]),
    );
  }
}