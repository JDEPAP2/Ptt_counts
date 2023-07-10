import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/PeopleController.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:cuentas_ptt/views/widgets/Person_item.dart';
import 'package:cuentas_ptt/views/widgets/modals/Add_Person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PeopleView extends StatefulWidget{
  Function getState;
   PeopleView({super.key, required this.getState});

  @override
  _PeopleState createState() => _PeopleState(getState: getState);
}

class _PeopleState extends State<PeopleView>{
  Function getState;
  _PeopleState({required this.getState});
  List people = List.empty(growable: true);
  bool rtype = false;

  Future<void> handleAsync() async{
    await handlePeople();

  }

    @override
  void initState() {
    rtype = getState();
    handleAsync();
    super.initState();

  }

  Future<void> handlePeople() async{
      print("handleeeeeeeeeeeeeee");
      people.clear();
      setState(() {});
      List<Person> peopleS = (await PeopleController.getPeople(limit: 50))??[];
      List aux = List.empty(growable: true);
      List<Record> records = await RecordsController.getRecords(getState())??[];
      if(peopleS.isNotEmpty){
        for(Person person in peopleS){
          List count = records.where((e) => e.nameId == person.id).toList();
          aux.add({"person": person,"index": count.length});
        }
      }
      people = aux;
      setState(() {});
  }


    @override
  Widget build(BuildContext context) {
    if(getState()!= rtype){
      handleAsync();}
    rtype = getState();

    handleModal(Widget modal) async{
      return await showDialog(
        context: context,
        builder: (builder) => modal);
    } 

    // handleProgress() async{
    //   try {
    //     showDialog(context: context, 
    //           builder: (context){
    //           return Center(child: CircularProgressIndicator(
    //             backgroundColor: Colors.grey,
    //             valueColor: AlwaysStoppedAnimation(AppColor.primary),
    //             strokeWidth: 10,
    //           ));
    //         });     
    //     people = await handlePeople();
    //     Navigator.of(context).pop();
    //     return people;
    //   } catch (e) {  
    //   }
    // }

    
    return Scaffold(
      backgroundColor: AppColor.black,
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: ()async{
          await handlePeople();
        },
        child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            alignment: Alignment.center,
            child: Text("Buscar Personas", style: TextStyle(color: AppColor.white,  fontSize: 25),),
          ),
          Container(
            child: Row(children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.only(top: 15, left: 15),
                child:Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                height: 50,
                child: TextField(
                  cursorColor: AppColor.light,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration( 
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                    hintText: "Buscar Persona"
                  ),
                ),
              )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: EdgeInsets.only(top: 15, left: 10, right: 15),
                child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                height: 50,
                child: InkWell(
                  splashColor: AppColor.black,
                  onTap: () async {
                    await handleModal(AddPerson());
                    await handlePeople();
                  },
                  child: Icon(Icons.add_rounded, color: AppColor.dark,size: 35)
                )
                ),
              )
            ]),
          ),

          SizedBox(height: 20),
          people.isNotEmpty? ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i){
              return Container(
                      padding: EdgeInsets.symmetric(horizontal:20, vertical: 5),
                      child: PersonItem(getState: getState, index: ()=> people[i]["index"], person: people[i]["person"], update: ()=>handlePeople())
                    );  
            }, 
            separatorBuilder: (context, i){
              return SizedBox();
            }, 
            itemCount: people.length): Center(heightFactor: 10 ,child: Text("No hay personas aun con " + (!rtype? "entradas": "salidas"), style: TextStyle(color: AppColor.white.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 17) ,)),
        ],
      ))
    );
  }

}