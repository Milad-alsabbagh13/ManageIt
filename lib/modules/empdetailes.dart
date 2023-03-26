import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manageitplus/shared/cubit/cubit.dart';
import 'package:manageitplus/shared/styles/constances.dart';
import '../shared/components/componet.dart';
import '../shared/cubit/states.dart';
class EmpDetails extends StatelessWidget {
  final String branchname;
  final String empcategory;
  final String  empname;
  final int initialsalary;
  const EmpDetails({super.key, required this.branchname,required this.empcategory,required this.empname,required this.initialsalary});
  ManageItPlusCubit cubit(context) =>BlocProvider.of(context);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var discountcontroller = TextEditingController();
    var reasoncontroller = TextEditingController();
    return BlocConsumer<ManageItPlusCubit,MangeItPlusCubitStates>(
        listener: (context,state){},
        builder: (context,state){
          var empdetailslist=cubit(context).empdetailslist;
          return Scaffold(
            backgroundColor: backgroundcolor,
            appBar: AppBar(
              backgroundColor: backgroundcolor
              ,title: Text('$empname '),),
            body: ConditionalBuilder(
              fallback: (context)=> Center(child: Text('Here you can add discounts for $empname',style: const TextStyle(color: Colors.white,fontSize: 24.0,),textAlign:TextAlign.center,)),
              condition: (empdetailslist.isNotEmpty),
              builder:(context) =>Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ListView.separated(
                            itemBuilder:
                                (context,index)=>Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 2.0),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: index%2==0 ?listviewcolor:listviewseparatorcolr, ),
                                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                                // color: index%2==0 ?listviewcolor:listviewseparatorcolr,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start ,
                                      children: [
                                        Text(empdetailslist[index]['reason'],style: const TextStyle(color: Colors.black87,fontSize: 28),),
                                        Text(empdetailslist[index]['date'],style: const TextStyle(color: Colors.black87,fontSize: 16),)
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('${empdetailslist[index]['discount'].toString()} \$',style: const TextStyle(color: Colors.black87,fontSize: 18)),
                                        TextButton(onPressed: ()
                                        {
                                              showDialog(context: context, builder: (context)=>AlertDialog(
                                                title: Row(
                                                  children: const [
                                                    Icon(Icons.sim_card_alert_outlined,color: Colors.red,),
                                                    SizedBox(width: 5.0,),
                                                    Text('ATTENTION'),
                                                  ],
                                                ),
                                                content: Text('you are about to delete this discount for $empname '),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    cubit(context).deleteElement(id: empdetailslist[index]['id'], branchname: branchname, empcategory: empcategory, empname: empname, initsalary: initialsalary);
                                                    Navigator.pop(context);
                                                  },
                                                      child: const Text('YES')),
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: const Text('NO'))
                                                ],
                                              ));
                                              },
                                            child: Text('remove',style: TextStyle(color:canceliconcolor ),))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                                ),
                            separatorBuilder:(context,index)=> Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Container(
                          width: double.infinity,
                          height: 3.0,
                          color: listviewseparatorcolr,
                        ),
                            ),
                            itemCount: empdetailslist.length),
                      ),
                      if(empdetailslist.length>1)
                        TextButton(onPressed: (){
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title: Row(
                              children: const [
                                Icon(Icons.sim_card_alert_outlined,color: Colors.red,),
                                SizedBox(width: 5.0,),
                                Text('ATTENTION'),
                              ],
                            ),
                            content: Text('you are about to delete this discount for $empname '),
                            actions: [
                              TextButton(onPressed: (){
                                cubit(context).deleteempdetails(branchname: branchname, empcategory: empcategory, empname: empname, initsalary: initialsalary);
                                Navigator.pop(context);
                              },
                                  child: const Text('YES')),
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: const Text('NO'))
                            ],
                          ));
                        }, child: Text('Delete All',style: TextStyle(color: canceliconcolor,fontSize: 16.0),)),
                      Container(height: 70.0,)

                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: Container(
              height: 70.0,
              color:Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('TOTAL:',style: TextStyle(fontSize: 24.0,color: Colors.white),),
                  const SizedBox(width: 8.0,),
                  Text('${cubit(context).salary.toString()} \$',style: const TextStyle(fontSize: 24.0,color: Colors.white),)
                ],
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
                                  child: defaultFormField(label: 'discount reason',
                                      error: 'please Enter discount reason',
                                      prefix: Icons.person,
                                      controller: reasoncontroller),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                                  child: defaultFormField(label: 'discount amount',
                                      error: 'please Enter discount amount',
                                      prefix: Icons.money_off,
                                      keyboard: TextInputType.number,
                                      controller:discountcontroller),
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
                                          cubit(context).insertIntoEmpDetailestable(branchname: branchname, empcategory: empcategory, empname: empname, reason: reasoncontroller.text, date: DateTime.now().toString().substring(
                                              0, 10), discount: int.parse(discountcontroller.text),initsalary: initialsalary);
                                          discountcontroller.clear();
                                          reasoncontroller.clear();
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
                  Icon(Icons.money_off_csred_outlined,color: backgroundcolor,size: 45,),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.minimize,size: 30,color: Colors.white,),
                  )
                ],
              ),),
          );
        });
  }
}

