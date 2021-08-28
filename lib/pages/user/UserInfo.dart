import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  static const routeName = '/user/info';

  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    // TODO: implement build
    return Scaffold(
        appBar: MyAppBar("User info"),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            buildName(user!),
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
            //const SizedBox(height: 48),
            //buildAbout(user),
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
