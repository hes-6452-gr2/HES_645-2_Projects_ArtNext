import 'package:artnext/common/Constants.dart';
import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyDrawer.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:artnext/widget/readTimeStamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ListEventsFilteredScreen.dart';
import 'manage/CreateEvenementScreen.dart';

export 'ListEventsScreen.dart';

class ListEventsScreen extends StatefulWidget {
  static const routeName = '/events';
  var selectedOrderBy = "Start date";
  var orderByFirebase = "startDate";
  List<String> myList = [];

  ListEventsScreenState createState() {
    return ListEventsScreenState();
  }
}

class ListEventsScreenState extends State<ListEventsScreen> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    // print("ListEventScreen - user = " + user.toString());
    // print("ListEventScreen - selectedOrderBy = " + widget.selectedOrderBy);
    // print("ListEventScreen - orderByFirebase = " + widget.orderByFirebase);
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Text("Events"),
        backgroundColor: Colors.brown[400],
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => showSortDialog(context, value),
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(''
                    'events')
                    .orderBy(widget.orderByFirebase)
                    //.where('endDate', isGreaterThan: DateTime.now())
                    .snapshots(),
                builder: buildEventsList,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: user!.isServiceProvider
          ? FloatingActionButton(
              elevation: 0.0,
              onPressed: () {
                Navigator.pushNamed(context, CreateEvenementScreen.routeName);
              },
              child: const Icon(Icons.add),
            )
          : Container(),
      drawer: MyDrawer(""),
    );
  }

  Widget buildEventsList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      // List<String> myList = [];
      return Column(
        children: <Widget>[
          Text(
            readTimestampYear(Event.fromJson(snapshot.data!.docs[0])
                .startDate
                .millisecondsSinceEpoch),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot eventFromFirebase =
                      snapshot.data!.docs[index];
                  //log(event.reference.id);
                  Event event = Event.fromJson(eventFromFirebase);
                  // log("ListEventsScreen - buildEventsList - event #" +
                  //     index.toString() +
                  //     " = " +
                  //     event.id);

                  var datum = readTimestamptoDate(
                      event.startDate.millisecondsSinceEpoch);
                  var eventTypeTransform = event.type
                      .toString()
                      .toLowerCase()
                      .replaceAll('eventtypeenum.', '');


                  if(!widget.myList.contains(event.city.toString())){
                    widget.myList.add(event.city.toString());
                  }else{
                    // print(event.city.toString());
                  }

                  // print("MA LISTE <<" + widget.myList.toString());
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text((event.title.length > 100)
                          ? event.title.substring(0, 100) + ("[...]")
                          : event.title),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                            eventTypeTransform.substring(0, 1).toUpperCase() +
                                eventTypeTransform.substring(
                                  1,
                                )),
                      ),
                      leading: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: ClipRRect(
                            // borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            child: FadeInImage(
                          image: NetworkImage(event.image),
                          placeholder:
                              AssetImage('assets/images/placeholder.jpg'),
                          imageErrorBuilder: (BuildContext context,
                              Object exception, StackTrace? stacktrace) {
                            return Container(
                              child: FadeInImage(
                                image:
                                    AssetImage('assets/images/placeholder.jpg'),
                                placeholder:
                                    AssetImage('assets/images/placeholder.jpg'),
                              ),
                            );
                          },
                        )),
                      ),
                      onTap: () => {
                        Navigator.pushNamed(
                            context, DisplayEvenementScreen.routeName,
                            arguments: event)
                      },
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(datum),
                          ),
                          Text(event.city),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                }),
          ),
        ],
      );
    } else if (snapshot.connectionState == ConnectionState.done &&
        !snapshot.hasData) {
      // Handle no data
      return Center(
        child: Text("No events found."),
      );
    } else {
      // Still loading
      return Center(child: CircularProgressIndicator());
    }
  }

  void showSortDialog(BuildContext context, String value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //return StatefulBuilder(
          //    builder: (BuildContext builder, StateSetter setState) {

          if(value.toString() == 'Sorted by'){
          return AlertDialog(
            title: Text(value.toString()),
            content: Container(
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: widget.selectedOrderBy,
                    items: <String>['Start date', 'End date', 'Title']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.selectedOrderBy = value!;
                        switch (value) {
                          case 'Start date':
                            widget.orderByFirebase = 'startDate';
                            break;
                          case 'End date':
                            widget.orderByFirebase = 'endDate';
                            break;
                          case 'Title':
                            widget.orderByFirebase = 'title';
                            break;
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
          }else{
            return AlertDialog(
              title: Text(value.toString()),
              content: Container(
                child: Wrap(
                  children: [
                    // TODO Faire une boucle pour créer le bouton plus simplement
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(
                          context, ListEventsFilteredScreen.routeName,
                          arguments: 'concert');
                    },
                        child: Text('concert')),
                    SizedBox(width: 5),
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(
                          context, ListEventsFilteredScreen.routeName,
                          arguments: 'undefined');
                    },
                        child: Text('undefined')),
                    SizedBox(width: 5),
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(
                          context, ListEventsFilteredScreen.routeName,
                          arguments: 'opening');
                    },
                        child: Text('opening')),
                    SizedBox(width: 5),
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(
                          context, ListEventsFilteredScreen.routeName,
                          arguments: 'exhibition');
                    },
                        child: Text('exhibition')),
                    DropdownButton<String>(
                      items: widget.myList
                        .map((String citylist){

                      return DropdownMenuItem<String>(
                        value: citylist,
                        child: Text(citylist),
                      );
                    }).toList(),
                      onChanged: (citylist) {
                        Navigator.pushNamed(
                                  context, ListEventsFilteredScreen.routeName,
                                  arguments: citylist);
                      },
                    )
                  ],
                ),
              ),
            );
          }


          //});
        });
  }
}
