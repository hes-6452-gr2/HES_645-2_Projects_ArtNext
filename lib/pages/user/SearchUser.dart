import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchUser extends StatefulWidget {
  static const routeName = '/user/search';

  _SearchUser createState() => _SearchUser();
}

class _SearchUser extends State<SearchUser> {
  List _resultsList = [];
  var showResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    searchResultList();
  }

  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('users');

  Future searchByName(String text) {
    return _collectionRef
        .where('firstname', isEqualTo: 'TestAccount')
        .get();
  }

  searchResultList() {
    // TODO A implémenter, tests Sylvain
    if (_searchController.text != ""){
      print("Il y a des paramètres");
      final temp = searchByName('toto');
      // showResults.add(searchByName(_searchController.text.toString()));
      // searchByName(_searchController.text).then((QuerySnapshot docs ) => showResults.add(docs.docs.toString()));

      showResults.add("-");

    }else{
      print("Il n'y a pas de paramètre");
      showResults.clear();
    }

    setState(() {
      _resultsList = showResults;
    });

  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar("Search a user", false),
        body: Container(
          child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
    ),
    ),
            Expanded(
              child: ListView.builder(
                itemCount: _resultsList.length,
                itemBuilder: (context, index) {
                  return _listItem(context, _resultsList[index]);
                }
              )
            )
          ]
    ),
    ));
  }

  _listItem(context, _list){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.brown[400],
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(_list),
              )
            ]
          )
        ]
      )
    );
  }





}
