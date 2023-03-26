import 'package:flutter/material.dart';
import 'package:manageitplus/modules/empcat.dart';
import 'package:manageitplus/shared/styles/constances.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/componet.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
class Branch extends StatelessWidget {
  const Branch({Key? key}) : super(key: key);
  ManageItPlusCubit cubit(context) =>BlocProvider.of(context);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var branchnamecontroller = TextEditingController();
    return BlocConsumer<ManageItPlusCubit,MangeItPlusCubitStates>(
      listener: (context,state){
      },
      builder: (context, state) {
        var branchlist=cubit(context).branchlist;
        return Scaffold(
          backgroundColor: backgroundcolor,
          body:
          ConditionalBuilder(
            fallback: (context)=>const Center(child: Text('Here you can add branches for your work',style: TextStyle(color: Colors.white,fontSize: 24.0,),textAlign:TextAlign.center,)),
            condition: (branchlist.isNotEmpty),
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
                                 Icon(Icons.business,size: 50.0,color: listviewseparatorcolr,),
                                 IconButton(onPressed: (){
                                     showDialog(context: context, builder: (context)=>AlertDialog(
                                       title: Row(
                                         children: const [
                                           Icon(Icons.sim_card_alert_outlined,color: Colors.red,),
                                           SizedBox(width: 5.0,),
                                           Text('ATTENTION'),
                                         ],
                                       ),
                                       content: Text('you are about to delete ${branchlist[index]['branchname']} branch and all employees working in it'),
                                       actions: [
                                         TextButton(onPressed: (){
                                           cubit(context).deletebranch(branchname: branchlist[index]['branchname']);
                                           // cubit(context).deleteBarElement(id: barmanlist[index]['id'],barmanname: barmanname);
                                           Navigator.pop(context);
                                         },
                                             child: const Text('YES')),
                                         TextButton(onPressed: (){
                                           Navigator.pop(context);
                                         }, child: const Text('NO'))
                                       ],
                                     ));
                                 }, icon: Icon(Icons.cancel_outlined,color: canceliconcolor,size: 35,)),
                               ],
                             )),
                          Container(width: 4,color: listviewseparatorcolr,child: const SizedBox(height: 70,),),
                          Expanded(
                            child: Container(
                              height: 70,
                                decoration: BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),color: listviewcolor),
                              child: TextButton(child:Text(branchlist[index]['branchname'].toString(),style: const TextStyle(fontSize: 30.0,color: Colors.white)), onPressed: () {
                                cubit(context).getEmpCategoryDatabase(database: cubit(context).database
                                     , branchname: branchlist[index]['branchname']
                                );
                                navigateTo(context, EmpCategory(branchname: branchlist[index]['branchname'].toString()));
                              },),
                            ),
                          ),
                      ],
                  ),
                  ),
                    separatorBuilder:(context,index)=>const SizedBox(height: 30.0,),
                    itemCount: branchlist.length),
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
                              child: defaultFormField(label: 'Branch Name',
                                  error: 'please Enter branch name',
                                  prefix: Icons.apartment_sharp,
                                  controller: branchnamecontroller),
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
                                    cubit(context).insertIntoBranchtable(branchname: branchnamecontroller.text);
                                    branchnamecontroller.clear();
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
              Icon(Icons.business,color: backgroundcolor,size: 45,),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.add,size: 30,color: Colors.white,),
              )
            ],
          ),),
        );
      },);
  }
}
