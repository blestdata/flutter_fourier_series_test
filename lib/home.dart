import 'package:flutter/material.dart';
import 'base_fourier/base_fourier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState () => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flutter Fourier Series Demo Page')
      ),
      drawer: Drawer(
        backgroundColor: Colors.white70,
        child: Column(
          children:  <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  const DrawerHeader(
                    child: Column(
                        children: <Widget>[
                          Row(
                              children: [
                                Text("Welcome Back User"),
                                Icon(Icons.supervised_user_circle_outlined)
                              ]
                          ),
                          Text("Please login to get personalized access")
                        ]
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 0.2,
                  ),
                  // Drawer List tiles for Pages
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.sports_baseball_rounded),
                    title: const Text('Base Fourier'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BaseFourierSeriesVisualization()));
                    },
                  ),
                  // Drawer List tiles for Pages finishes here, we have a black horizontal divider below then footer
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 0.2,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Row(
                children: <Widget>[
                  TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      // Have kept it as a simple print for now,
                      // If auth is required for the application, will create dedicated process here
                      print("Logout");
                      },
                  ),
                  const Text('Flutter Fourier Series - v1.0.0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}