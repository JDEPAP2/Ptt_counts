import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/views/widgets/Person_item.dart';
import 'package:cuentas_ptt/views/widgets/modals/Add_Person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeopleView extends StatefulWidget{
  Function getState;
   PeopleView({super.key, required this.getState});

  @override
  _PeopleState createState() => _PeopleState(getState: getState);
}

class _PeopleState extends State<PeopleView>{
  Function getState;
  _PeopleState({required this.getState});

    @override
  Widget build(BuildContext context) {

    bool rtype = getState();


    handleModal(Widget modal) async{
      return await showDialog(
        context: context,
        builder: (builder) => modal);
    } 
    return Scaffold(
      backgroundColor: AppColor.black,
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
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
                  onTap: () => {handleModal(AddPerson())},
                  child: Icon(Icons.add_rounded, color: AppColor.dark,size: 35)
                )
                ),
              )
            ]),
          ),

          SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i){
              return Container(
                      padding: EdgeInsets.symmetric(horizontal:20, vertical: 5),
                      child: PersonItem(getState: getState)
                    );  
            }, 
            separatorBuilder: (context, i){
              return SizedBox();
            }, 
            itemCount: 10),
            
        ],
      ),
      
    );
  }

}