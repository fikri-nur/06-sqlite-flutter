import 'package:flutter/material.dart';
import 'package:sqlite_flutter/dbHelper/dbhelper.dart';
import 'package:sqlite_flutter/view/entryform.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqlite_flutter/models/item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int count = 0;
  List<Barang> barangList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Item'),
        ),
        body: Column(
          children: [
            Expanded(
              child: createListView(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Tambah Item'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EntryForm()),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }

  ListView createListView() {
    TextStyle? textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
        itemCount: barangList.length,
        itemBuilder: (BuildContext context, int index) => Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.ad_units),
                ),
                title: Text(
                  barangList[index].name,
                  style: textStyle,
                ),
                subtitle: Text(barangList[index].price.toString()),
                trailing: GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: () async {
                    // 3 TODO: delete by id
                  },
                ),
                onTap: () async {
                   // 4 TODO: edit by id
                },
              ),
            ));
  }

  void updateListView() {
    final Future<Database> dbFuture = DBHelper.db();
    dbFuture.then((database) {
// TODO: get all item from DB
      Future<List<Barang>> itemListFuture = DBHelper.getItemList();
      itemListFuture.then((barangList) {
        setState(() {
          this.barangList = barangList;
          count = barangList.length;
        });
      });
    });
  }
}
