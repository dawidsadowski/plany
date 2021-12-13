import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/models/user_model.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupSettings extends StatefulWidget {
  const GroupSettings({Key? key}) : super(key: key);
  final String title = 'Twoje grupy';

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  List<Group>? selectedGroupList = [];
  List<Group> groupList = [];

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.email)
        .collection("groups")
        .get()
        .then((value) {
      for (var element in value.docs) {
        setState(() {
          var reference = FirebaseFirestore.instance.collection("groups").doc(element.id);
          selectedGroupList!.add(Group(element.id, reference));
        });
      }

      FirebaseFirestore.instance.collection("groups").get().then((value) {
        for (var element in value.docs) {
          Group group = Group(element.id, element.reference);

          print(selectedGroupList);

          for(var selectedGroup in selectedGroupList!) {
            if(selectedGroup.name == element.id) {
              group = selectedGroup;
            }
          }

          groupList.add(group);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaterialButton(
          height: 60,
          minWidth: double.infinity,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text('Wybierz grupy'),
          onPressed: () async {
            var list = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilterPage(
                  allTextList: groupList,
                  selectedUserList: selectedGroupList,
                ),
              ),
            );
            if (list != null) {
              setState(() {
                selectedGroupList = List.from(list);
              });
            }
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          selectedGroupList == null || selectedGroupList!.length == 0
              ? Expanded(
                  child: Center(
                    child: Text('Nie wybrano żadnej grupy'),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(selectedGroupList![index].name!),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: selectedGroupList!.length),
                ),
        ],
      ),
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key, this.allTextList, this.selectedUserList})
      : super(key: key);
  final List<Group>? allTextList;
  final List<Group>? selectedUserList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wybór grup"),
      ),
      body: SafeArea(
        child: FilterListWidget<Group>(
          listData: allTextList,
          selectedListData: selectedUserList,
          hideHeaderText: true,
          searchFieldHintText: "Wyszukaj grupy",
          allButtonText: "Wszystkie",
          resetButtonText: "Reset",
          applyButtonText: "Zatwierdź",
          buttonSpacing: 20,
          hideSelectedTextCount: true,
          onApplyButtonClick: (list) async {
            FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
            User? user = FirebaseAuth.instance.currentUser;

            var batch = firebaseFirestore.batch();
            var collection = firebaseFirestore
                .collection('users')
                .doc(user!.email)
                .collection('groups');
            var snapshots = await collection.get();

            for (var doc in snapshots.docs) {
              await doc.reference.delete();
            }

            for (var element in list!) {
              batch.set(
                  firebaseFirestore
                      .collection("users")
                      .doc(user.email)
                      .collection("groups")
                      .doc(element.name),
                  {'group': element.reference});
            }

            batch.commit();

            Navigator.pop(context, list);
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item!.name;
          },
          choiceChipBuilder: (context, item, isSelected) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
              )),
              child: Text(item.name),
            );
          },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (list, text) {
            /// When text change in search text field then return list containing that text value
            ///
            ///Check if list has value which matchs to text
            if (list!.any((element) =>
                element.name!.toLowerCase().contains(text.toLowerCase()))) {
              /// return list which contains matches
              return list
                  .where((element) =>
                      element.name!.toLowerCase().contains(text.toLowerCase()))
                  .toList();
            }
            return [];
          },
        ),
      ),
    );
  }
}

class Group {
  final String? name;
  final DocumentReference? reference;

  Group(this.name, this.reference);
}
