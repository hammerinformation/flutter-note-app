import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Github  @hammerinformation
void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var myList = List<String>();
  var textEditingController = TextEditingController();

  void saveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("list", myList);
  }

  void getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList("list") != null) {
      setState(() {
        myList = sharedPreferences.getStringList("list");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CupertinoColors.white,
        floatingActionButton: FloatingActionButton(
            backgroundColor: CupertinoColors.white,
            child: Icon(
              CupertinoIcons.add,
              color: CupertinoColors.systemBlue,
            ),
            onPressed: () {
              var alert = CupertinoAlertDialog(
                title: Text('New'),
                actions: [
                  Column(
                    children: [
                      CupertinoTextField(
                        maxLines: 5,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                        placeholder: ' ',
                        textAlign: TextAlign.center,
                        controller: textEditingController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CupertinoButton(
                        color: CupertinoColors.systemBlue,
                        onPressed: () {
                          if (textEditingController.text.length > 0) {
                            setState(() {
                              myList.add(textEditingController.text);
                              textEditingController.clear();
                              saveData();
                              getData();
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('Save'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              );
              showCupertinoDialog(
                  context: context, builder: (BuildContext context) => alert);
            }),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: myList.length,
              itemBuilder: (context, index) {
                return Card(
                    shadowColor: CupertinoColors.black,
                    child: ListTile(
                      title: Center(
                          child: Text(
                        myList[index],
                        style: TextStyle(
                            color: CupertinoColors.darkBackgroundGray),
                      )),
                      leading: Text(
                        (index + 1).toString(),
                        style: TextStyle(color: CupertinoColors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          CupertinoIcons.delete_simple,
                          color: CupertinoColors.systemGrey2,
                        ),
                        onPressed: () {
                          setState(() {
                            myList.removeAt(index);
                            saveData();
                            getData();
                          });
                        },
                      ),
                    ));
              },
            ),
          ),
        ));
  }
}
