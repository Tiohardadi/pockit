import 'package:flutter/material.dart';
import 'package:pockit/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userData = {
    'fullname': '',
    'gender': '',
    'phoneNumber': '',
    'email': ''
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    
    if (userDataString != null) {
      setState(() {
        userData = json.decode(userDataString);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/logo_putih_appbar.png',
                width: 100,
                height: 25,
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF5383FF),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),

                          // Profile picture with background
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Color(0xFFF5B5B5), // Pink background
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Avatar placeholder
                                  Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Color(0xFF6B705C),
                                  )
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Name
                          Text(
                            userData['fullname'] ?? 'User Name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Phone number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                userData['phoneNumber'] ?? '-',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Email
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                userData['email'] ?? '-',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Menu options
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.edit, color: Colors.black54),
                              title: Text(
                                'Edit Profile',
                                style: TextStyle(fontSize: 18, color: Colors.black87),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.black54,
                              ),
                              onTap: () {
                                // Edit profile action
                              },
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade300),
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.logout, color: Colors.black54),
                              title: Text(
                                'Logout',
                                style: TextStyle(fontSize: 18, color: Colors.black87),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.black54,
                              ),
                              onTap: () {
                                AuthService.logout(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}