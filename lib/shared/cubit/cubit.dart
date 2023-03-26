import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manageitplus/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class ManageItPlusCubit extends Cubit<MangeItPlusCubitStates>{
  ManageItPlusCubit():super(ManageItplusCubitInitialState());
  static ManageItPlusCubit get(context)=>BlocProvider.of(context);
 Database? database;
  void createDatabase() {
    if (database == null) {
      openDatabase(
          'ManageIT.db',
          version: 1,
          onCreate: (database, version) {
        print('Database Created');
        database
            .execute(
            'CREATE TABLE branchtable (id INTEGER PRIMARY KEY, branchname TEXT )');
        database
            .execute(
            'CREATE TABLE empcategorytable (id INTEGER PRIMARY KEY, branchname TEXT ,empcategory TEXT)');
        database
            .execute(
            'CREATE TABLE emptable (id INTEGER PRIMARY KEY, branchname TEXT ,empcategory TEXT, empname TEXT, initsalary INTEGER)');
        database
            .execute(
            'CREATE TABLE empdetailstable (id INTEGER PRIMARY KEY, branchname TEXT ,empcategory TEXT, empname TEXT, reason TEXT , date TEXT ,discount INTEGER)').
        then((value) {
          print('Table created');
        }).catchError((e) {
          print('Error When Creating Table ${e.toString()}');
        });
          },
        onOpen: (database) {
          print('database opened');
        },
      ).then((value) {
        database = value;
        getBranchDatabase(database: database);
        emit(ManageItPlusCubitCrateDataBaseState());
      });
    } else {
      emit(ManageItPlusCubitCrateDataBaseState());
    }
  }
        Future<void> insertIntoBranchtable({
    required String branchname,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO branchtable(branchname) VALUES("$branchname")')
          .then((value) {
        print('$value Table insered seccesfuly');
        getBranchDatabase(database: database);
        emit(ManageItPlusCubitInsertIntoBranchtableState());
      }).catchError((e) {
        print(' Error When Inserting Table ${e.toString()}');
      });
    });
  }
 List<Map>branchlist=[];
  Future<void> getBranchDatabase({required Database? database}) async {
    if (database == null) {
      print("Error: database is null");
      return;
    }
    branchlist = [];
    await database.rawQuery('SELECT * FROM branchtable').then((value) {
      value.forEach((element) {
        branchlist.add(element);
      });
      print(value);
    });
    emit(ManageItPlusCubitGetBranchtableState());
  }
  Future <void> deletebranch({
    required String branchname,
  }) async {
    await database!.rawDelete('DELETE FROM branchtable WHERE branchname = ?', [branchname]);
     await database!.rawDelete('DELETE FROM empcategorytable WHERE branchname = ? ', [branchname]);
     await database!.rawDelete('DELETE FROM emptable WHERE branchname = ? ', [branchname]);
    await database!.rawDelete('DELETE FROM empdetailstable WHERE branchname = ? ', [branchname])
        .then((value) {
      getBranchDatabase(database:database,);
      emit(ManageItPlusCubitDeleteBranchState());
    });
  }
  Future<void> insertIntoEmpcategorytable({
    required String branchname,
    required String empcategory
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO empcategorytable (branchname,empcategory) VALUES("$branchname","$empcategory")')
          .then((value) {
        print('$value Table insered seccesfuly');
        getEmpCategoryDatabase(database: database,branchname: branchname);
        emit(ManageItPlusCubitInsertIntoEmpCategorytableState());
      }).catchError((e) {
        print(' Error When Inserting Table ${e.toString()}');
      });
    });
  }
  List<Map>empcategorylist=[];
  Future<void> getEmpCategoryDatabase({required Database? database,
  required String branchname
  }) async {
    if (database == null) {
      print("Error: database is null");
      return;
    }
    empcategorylist = [];
    await database.rawQuery('SELECT * FROM empcategorytable').then((value) {
      value.forEach((element) {
         if(element['branchname']==branchname) {
           empcategorylist.add(element);
         }
      });
      print(value);
    });
    emit(ManageItPlusCubitGetEmpCategoryDatabaseState());
  }
  Future <void> deleteempcategory({
     required String branchname,
    required String empcategory
  }) async {
    await database!.rawDelete('DELETE FROM empcategorytable WHERE empcategory = ? AND branchname = ? ', [empcategory,branchname]);
   await database!.rawDelete('DELETE FROM emptable WHERE empcategory = ? AND branchname = ? ', [empcategory,branchname]);
    await database!.rawDelete('DELETE FROM empdetailstable WHERE empcategory = ? AND branchname = ? ', [empcategory,branchname])
        .then((value) {
      getEmpCategoryDatabase(database:database,branchname: branchname);
      emit(ManageItPlusCubitDeleteEmpCategoryState());
    });
  }
  Future<void> insertIntoEmptable({
    required String branchname,
    required String empcategory,
    required String empname,
    required int initilasalary
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO emptable (branchname,empcategory,empname,initsalary) VALUES("$branchname","$empcategory","$empname","$initilasalary")')
          .then((value) {
        print('$value Table insered seccesfuly');
        getEmpsDatabase(database: database,branchname: branchname,empcategory: empcategory);
        emit(ManageItPlusCubitInsertIntoEmptableState());
      }).catchError((e) {
        print(' Error When Inserting Table ${e.toString()}');
      });
    });
  }
  List<Map>empslist=[];
  Future<void> getEmpsDatabase({required Database? database,
    required String branchname,
    required String empcategory,
  }) async {
    if (database == null) {
      print("Error: database is null");
      return;
    }
    empslist = [];
    await database.rawQuery('SELECT * FROM emptable').then((value) {
      value.forEach((element) {
        if(element['branchname']==branchname && element['empcategory']==empcategory) {
          empslist.add(element);
        }
      });
      print(value);
    });
    emit(ManageItPlusCubitGetEmpsDatabaseState());
  }
  Future <void> deleteemp({
    required String branchname,
    required String empcategory,
    required String empname
  }) async {
    await database!.rawDelete('DELETE FROM emptable WHERE empcategory = ? AND branchname = ? AND empname = ?', [empcategory,branchname,empname]);
    await database!.rawDelete('DELETE FROM empdetailstable WHERE empcategory = ? AND branchname = ? AND empname = ?', [empcategory,branchname,empname])

        .then((value) {
      getEmpsDatabase(database:database,branchname: branchname,empcategory: empcategory);
      emit(ManageItPlusCubitDeleteEmpState());
    });
  }
  Future<void> insertIntoEmpDetailestable({
    required String branchname,
    required String empcategory,
    required String empname,
    required String reason,
    required String date,
    required int discount,
    required int initsalary
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO empdetailstable (branchname,empcategory,empname,reason,date,discount) VALUES("$branchname","$empcategory","$empname","$reason","$date","$discount")')
          .then((value) {
        print('$value Table insered seccesfuly');
        getEmpDetailsDatabase(database: database,branchname: branchname,empcategory: empcategory,empname:empname,initsalary: initsalary);
        emit(ManageItPlusCubitInsertIntoEmpDetailstableState());
      }).catchError((e) {
        print(' Error When Inserting Table ${e.toString()}');
      });
    });
  }
  int salary =0;
  List<Map>empdetailslist=[];
  Future<void> getEmpDetailsDatabase({required Database? database,
    required String branchname,
    required String empcategory,
    required String empname,
     required int initsalary
  }) async {
    if (database == null) {
      print("Error: database is null");
      return;
    }
    empdetailslist = [];
    salary=initsalary;
    await database.rawQuery('SELECT * FROM empdetailstable').then((value) {
      value.forEach((element) {
        if(element['branchname']==branchname && element['empcategory']==empcategory && element['empname']==empname) {
          empdetailslist.add(element);
        }
        int discount=element['discount'] as int;
        salary=salary-discount;

      });
      print(value);
    });
    emit(ManageItPlusCubitGetEmpDetailsDatabaseState());
  }
  Future <void> deleteempdetails({
    required String branchname,
    required String empcategory,
    required String empname,
    required int initsalary
  }) async {
    await database!.rawDelete('DELETE FROM empdetailstable WHERE empcategory = ? AND branchname = ? AND empname = ?', [empcategory,branchname,empname]).then((value) {
      getEmpDetailsDatabase(database:database,branchname: branchname,empcategory: empcategory,empname:empname,initsalary: initsalary);
      emit(ManageItPlusCubitDeleteEmpDetailsState());
    });
  }
  Future<void>deleteElement({
  required id,
    required String branchname,
    required String empcategory,
    required String empname,
    required int initsalary
})async{

    await database!.rawDelete('DELETE FROM empdetailstable WHERE id = ?', [id]).then((value) {
      getEmpDetailsDatabase(database:database,branchname: branchname,empcategory: empcategory,empname:empname,initsalary: initsalary);
      emit(ManageItPlusCubitDeleteEmpDetailsState());
    });
  }
}