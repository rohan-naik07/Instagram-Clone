import 'package:first_flutter_project/futils/auth.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:first_flutter_project/posts/create/photos.dart';
import 'package:first_flutter_project/posts/feed.dart';
import 'package:first_flutter_project/posts/search.dart';
import 'package:first_flutter_project/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var infoProvider;

  static List<Widget> _widgetOptions = <Widget>[
    FeedPage(),
    PhotosPage(),
    SearchPage(),
    ProfilePage(userName: ""),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<dynamic> getUserInfo(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    infoProvider = context.read<UserModel>();
    if(infoProvider.info==null){
      var user = await Auth().getUser(prefs.getString("user-email"));
      infoProvider.add(user);
      return user;
    }
    return infoProvider.info;
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<dynamic>(
        future: getUserInfo(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return _widgetOptions.elementAt(_selectedIndex);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black26,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label : 'Home',
                backgroundColor: Colors.black
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined,),
                label : 'Add',
                backgroundColor: Colors.black
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                backgroundColor: Colors.black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.black,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5
      ),
    );
  }
}
