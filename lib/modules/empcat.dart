import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manageitplus/modules/empnames.dart';
import 'package:manageitplus/shared/cubit/cubit.dart';
import 'package:manageitplus/shared/styles/constances.dart';
import '../shared/components/componet.dart';
import '../shared/cubit/states.dart';
class EmpCategory extends StatelessWidget {
  final String branchname;

  const EmpCategory({super.key, required this.branchname});
  ManageItPlusCubit cubit(context) =>BlocProvider.of(context);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var empcategory = TextEditingController();
    return BlocConsumer<ManageItPlusCubit,MangeItPlusCubitStates>(
        listener: (context,state){},
        builder: (context,state){
          var empcategorylist=cubit(context).empcategorylist;
          return Scaffold(
            appBar: AppBar(
            backgroundColor: backgroundcolor
            ,title: Text('$branchname Employees Categories'),),
            backgroundColor: backgroundcolor,
            body: ConditionalBuilder(
              fallback: (context)=>const Center(child: Text('Here you can add employees categories for your work',style: TextStyle(color: Colors.white,fontSize: 24.0,),textAlign:TextAlign.center,)),
              condition: (empcategorylist.isNotEmpty),
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
                                    Icon(Icons.category,size: 50.0,color: listviewseparatorcolr,),
                                    IconButton(onPressed: (){
                                        showDialog(context: context, builder: (context)=>AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(Icons.sim_card_alert_outlined,color: Colors.red,),
                                              SizedBox(width: 5.0,),
                                              Text('ATTENTION'),
                                            ],
                                          ),
                                          content: Text('you are about to delete ${empcategorylist[index]['empcategory']} category and all employees working as ${empcategorylist[index]['empcategory']} in $branchname' ),
                                          actions: [
                                            TextButton(onPressed: (){
                                              cubit(context).deleteempcategory(
                                                   branchname: empcategorylist[index]['branchname'],
                                                  empcategory: empcategorylist[index]['empcategory']);
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
                                ),
                            ),
                               Container(width: 4,color: listviewseparatorcolr,child: const SizedBox(height: 70,),),
                            Expanded(
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),color: listviewcolor),
                                child: TextButton(child:Text(empcategorylist[index]['empcategory'].toString(),style: const TextStyle(fontSize: 30.0,color: Colors.white)), onPressed: () {
                                  cubit(context).getEmpsDatabase(database: cubit(context).database, branchname: branchname, empcategory: empcategorylist[index]['empcategory']);
                                   navigateTo(context, EmpName(branchname: empcategorylist[index]['branchname'].toString(),empcategory: empcategorylist[index]['empcategory'].toString(),));
                                },),
                              ),
                            ),
                          ],
                        ),
                          ),
                      separatorBuilder:(context,index)=>const SizedBox(height: 30.0,),
                      itemCount: empcategorylist.length),
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
                                    child: defaultFormField(label: 'Category',
                                        error: 'please Enter Category',
                                        prefix: Icons.category,
                                        controller: empcategory),
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
                                            cubit(context).insertIntoEmpcategorytable(branchname: branchname,empcategory: empcategory.text);
                                            empcategory.clear();
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
                    Icon(Icons.category_outlined,color: backgroundcolor,size: 45,),
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
