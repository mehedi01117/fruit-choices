import 'package:flutter/material.dart';
import 'package:fruit_choices/Home/Drawer/mydrawer.dart';
import 'package:fruit_choices/Home/bottmbar/bottm_home.dart';
import 'package:fruit_choices/Home/seach_bar/usersearch.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int ConttenTableindex = 0;
  late List<Widget> tablenames;

  void initState() {
    super.initState();
    var authBox = Hive.box('authBox');
    String savedName = authBox.get('user_name', defaultValue: 'User');
    tablenames = [
      BottmHome(name:savedName),
      const Center(child: Text("Cart Page")), // ২ নম্বর পেজ
      const Center(child: Text("Message Page")), // ৩ নম্বর পেজ
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Mydrawer(),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: Usersearch(),
              );
              
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Icon(Icons.search_outlined, size: 25, color: Colors.black),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Icon(
              Icons.notification_add_outlined,
              size: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: tablenames[ConttenTableindex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: ConttenTableindex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.black,
          selectedFontSize: 14,
          unselectedFontSize: 14,

          enableFeedback: false,

          onTap: (value) {
            setState(() {
              ConttenTableindex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Message",
            ),
          ],
        ),
      ),
    );
  }
}
