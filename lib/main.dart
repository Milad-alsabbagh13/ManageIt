import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manageitplus/shared/cubit/cubit.dart';
import 'package:manageitplus/shared/cubit/states.dart';

import 'modules/branchpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context){
        return ManageItPlusCubit()..createDatabase();
      },
      child: BlocConsumer<ManageItPlusCubit,MangeItPlusCubitStates>(
        listener: (context,state){},
        builder: (context,state){
          return MaterialApp(
            home:Branch(),
          );
        },
      ),
    );
  }
}

