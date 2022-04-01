import 'package:flutter/material.dart';
import 'package:sqlite_flutter/models/item.dart';
import 'package:sqlite_flutter/dbHelper/dbhelper.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({
    Key? key,
    Item? item,
  }) : super(key: key);

  @override
  State<EntryForm> createState() => EntryFormState();
}

class EntryFormState extends State<EntryForm> {
  Item item = Item(name: '', price: 0);

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //kondisi
    if (item != null) {
      nameController.text = item.name;
      priceController.text = item.price.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: item == null ? Text('Tambah') : Text('Ubah'),
        leading: const Icon(Icons.keyboard_arrow_left),
      ),
      body: ListView(
        children: <Widget>[
          //nama barang
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (value) {
                //TODO: Method untuk form nama barang
              },
            ),
          ),
          //Harg barang
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga Barang',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (value) {
                //TODO: Method untuk form harga barang
              },
            ),
          ),
          //Tombol button
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                //tombol simpan
                Expanded(
                  child: ElevatedButton(
                    child: const Text(
                      'Save',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () async {
                      if (item == null) {
                        //tambah data
                        item = Item(
                            name: nameController.text,
                            price: int.parse(priceController.text));
                        await DBHelper.createItem(item);
                      } else {
                        //ubah data
                        item.name = nameController.text;
                        item.price = int.parse(priceController.text);
                      }
                      //kembali ke layar sebelumnya dengan membawa objek item
                      Navigator.pop(context, item);
                    },
                  ),
                ),
                Container(
                  width: 5.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text(
                      'Cancel',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
