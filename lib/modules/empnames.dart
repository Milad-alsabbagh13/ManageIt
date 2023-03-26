import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manageitplus/modules/empdetailes.dart';
import 'package:manageitplus/shared/cubit/cubit.dart';
import 'package:manageitplus/shared/styles/constances.dart';
import '../shared/components/componet.dart';
import '../shared/cubit/states.dart';
class EmpName extends StatelessWidget {
  final String branchname;
  final String empcategory;

  const EmpName({super.key, required this.branchname,required this.empcategory});
  ManageItPlusCubit cubit(context) =>BlocProvider.of(context);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var empnamecontroller = TextEditingController();
    var empInitSalarycontroller = TextEditingController();
    return BlocConsumer<ManageItPlusCubit,MangeItPlusCubitStates>(
        listener: (context,state){},
        builder: (context,state){
          var empslist=cubit(context).empslist;
          return Scaffold(
            backgroundColor: backgroundcolor,
            appBar: AppBar(
              backgroundColor: backgroundcolor
              ,title: Text('$branchname $empcategory ' ),),
            body: ConditionalBuilder(
              fallback: (context)=> Center(child: Text('Here you can add $empcategory for your work',style: const TextStyle(color: Colors.white,fontSize: 24.0,),textAlign:TextAlign.center,)),
              condition: (empslist.isNotEmpty),
              builder:(context) =>Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: ListView.separated(
                      itemBuilder:
                          (context,index)=>Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 70.0,
                                width: 70.0,
                                decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),color: listviewcolor),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(Icons.person,size: 50.0,color: listviewseparatorcolr,),
                                    IconButton(onPressed: (){
                                      {
                                        showDialog(context: context, builder: (context)=>AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(Icons.sim_card_alert_outlined,color: Colors.red,),
                                              SizedBox(width: 5.0,),
                                              Text('ATTENTION'),
                                            ],
                                          ),
                                          content: Text('you are about to delete ${empslist[index]['empname']} and all his detail from $branchname $empcategory' ),
                                          actions: [
                                            TextButton(onPressed: (){
                                              cubit(context).deleteemp(
                                                  branchname: empslist[index]['branchname'],
                                                  empcategory: empslist[index]['empcategory'],
                                                empname: empslist[index]['empname']

                                              );
                                              Navigator.pop(context);
                                            },
                                                child: const Text('YES')),
                                            TextButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, child: const Text('NO'))
                                          ],
                                        ));

                                      }
                                    }, icon: Icon(Icons.cancel_outlined,color: canceliconcolor,size: 35,)),
                                  ],
                                )),
                            Container(width: 4,color: listviewseparatorcolr,child: const SizedBox(height: 70,),),
                            Expanded(
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),color: listviewcolor),
                                child: TextButton(child:Text(empslist[index]['empname'].toString(),style: const TextStyle(fontSize: 30.0,color: Colors.white)), onPressed: () {
                                  navigateTo(context, EmpDetails(branchname: branchname,empcategory:empcategory ,empname:empslist[index]['empname'] ,initialsalary:empslist[index]['initsalary'] ,));
                                  cubit(context).getEmpDetailsDatabase(database: cubit(context).database, branchname: branchname, empcategory: empcategory, empname: empslist[index]['empname'], initsalary: empslist[index]['initsalary']);
                                },),
                              ),
                            ),
                          ],
                        ),),
                      separatorBuilder:(context,index)=>const SizedBox(height: 30.0,),
                      itemCount: empslist.length),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: listviewseparatorcolr,
              onPressed: (){
                showModalBottomSheet(context: context,isScrollControlled: true,builder: (context)=>StatefulBuilder(
                    builder:(BuildContext context, StateSetter setState) {
                      return Padding(
                        padding:  EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: 350.0,
                          color: Colors.blueGrey,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                                  child: defaultFormField(label: 'employee name',
                                      error: 'please Enter employee name',
                                      prefix: Icons.person,
                                      controller: empnamecontroller),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                                  child: defaultFormField(label: 'employee initial salary',
                                      error: 'please Enter employee initial salary',
                                      prefix: Icons.monetization_on_outlined,
                                      keyboard: TextInputType.number,
                                      controller:empInitSalarycontroller),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      width: double.infinity,
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.blue,
                                      ),
                                      child: MaterialButton(onPressed: () {
                                        if (formKey.currentState!.validate()){
                                          cubit(context).insertIntoEmptable(branchname: branchname,empcategory: empcategory,empname: empnamecontroller.text,initilasalary: int.parse(empInitSalarycontroller.text));
                                          empnamecontroller.clear();
                                          empInitSalarycontroller.clear();
                                          Navigator.pop(context);
                                        }
                                      },

                                        child: const Text('Confirm', style: TextStyle(
                                            fontSize: 18.0, color: Colors.white),),)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.person,color: backgroundcolor,size: 45,),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.add,size: 30,color: Colors.white,),
                  )
                ],
              ),),
          );
        });
  }
}
//test for github proccess