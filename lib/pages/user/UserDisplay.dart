import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserDisplay extends StatefulWidget {
  static const routeName = '/user/display';

  _UserDisplayState createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as MyUser;

    return Scaffold(
        appBar: MyAppBar("User info", false),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            Center(child: buildUpgradeButton(user.isPremium)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  onPressed: () {},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      user.isPremium
                          ? FaIcon(
                        FontAwesomeIcons.solidStar,
                        size: 24,
                      )
                          : FaIcon(
                        FontAwesomeIcons.star,
                        size: 24,
                      ),
                      SizedBox(height: 2),
                      Text(
                        user.isPremium ? "Premium" : "Not premium",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24,
                  child: VerticalDivider(),
                ),
                MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  onPressed: () {},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      user.isServiceProvider
                          ? FaIcon(
                        FontAwesomeIcons.palette,
                        size: 24,
                      )
                          : FaIcon(
                        FontAwesomeIcons.user,
                        size: 24,
                      ),
                      SizedBox(height: 2),
                      Text(
                        user.isServiceProvider
                            ? "Service provider"
                            : "Classic account",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            buildMyEventsTitle(),
            const SizedBox(height: 24),
            Expanded(
              child: SizedBox(
                height: 400.0,
                child: StreamBuilder(stream: FirebaseFirestore.instance
                    .collection('events')
                    .where('listAttendees', arrayContains: user.uid)
                    .snapshots(),
                  builder: buildEventsList,
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget buildName(MyUser user) => Column(
    children: [
      Text(
        user.firstname + " " + user.lastname,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.uid,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildUpgradeButton(bool isPremium) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    child: Text(isPremium ? "Downgrade to CLASSIC" : "Upgrade to PREMIUM"),
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Not implemented yet 😉'),
          duration: Duration(seconds: 2)));
    },
  );

  Widget buildMyEventsTitle()  => Column(
    children: [
      Text(
        "My attendency history",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    ],
  );
}

Widget buildEventsList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return Column(
      children: <Widget>[
        Text("History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot eventFromFirebase = snapshot.data!.docs[index];

                Event event = Event.fromJson(eventFromFirebase);
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text((event.title.length > 100) ? event.title.substring(0,100)+("[...]") : event.title),
                    onTap: () => {
                      Navigator.pushNamed(context, DisplayEvenementScreen.routeName,
                          arguments: event)
                    },
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
