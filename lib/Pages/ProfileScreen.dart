import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Auth_Provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    userDetails.getUserDetails();
    User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Ahia', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('My Account',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Stack(
              children: [
                Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              child: Text('O',
                                  style: TextStyle(
                                      fontSize: 50, color: Colors.white)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      userDetails.snapshot != null
                                          ? '${userDetails.snapshot!['firstName']} ${userDetails.snapshot!['lastName']}'
                                          : 'Update Your Name',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white)),
                                  if (userDetails.snapshot!['email'] != null)
                                    Text('${userDetails.snapshot!['email']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white)),
                                  Text(user.phoneNumber!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (userDetails.snapshot != null)
                          ListTile(
                            tileColor: Colors.white,
                            leading: Icon(Icons.location_on,
                                color: Theme.of(context).primaryColor),
                            title: Text(userDetails.snapshot!['address'],
                                maxLines: 1),
                            subtitle: Text(userDetails.snapshot!['city'] +
                                ' - ' +
                                userDetails.snapshot!['state']),
                            trailing: GestureDetector(
                              child: Text('Change Address',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                              onTap: () {
                                // pushNewScreenWithRouteSettings(
                                //   context,
                                //   settings: RouteSettings(
                                //       name: SetDeliveryLocation.id),
                                //   screen: SetDeliveryLocation(),
                                //   withNavBar: false,
                                //   pageTransitionAnimation:
                                //       PageTransitionAnimation.cupertino,
                                // );
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: 10.0,
                    // top: 10.0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // pushNewScreenWithRouteSettings(
                        //   context,
                        //   settings: RouteSettings(name: UpdateProfile.id),
                        //   screen: UpdateProfile(),
                        //   withNavBar: false,
                        //   pageTransitionAnimation:
                        //       PageTransitionAnimation.cupertino,
                        // );
                      },
                    )),
              ],
            ),
            const ListTile(
                leading: Icon(Icons.history), title: Text('My Orders')),
            const Divider(),
            const ListTile(
                leading: Icon(Icons.comment_outlined),
                title: Text('My Ratings & Review')),
            const Divider(),
            const ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications')),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: const Text('Log Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                // pushNewScreenWithRouteSettings(
                //   context,
                //   settings: RouteSettings(name: WelcomeScreen.id),
                //   screen: WelcomeScreen(),
                //   withNavBar: false,
                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
