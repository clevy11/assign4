import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:io';

import 'calculator.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLanguageChanged;
  final List<Contact> contacts;
  final Function(XFile) onUpdateProfileImage;
  final XFile? profileImage;

  const HomeScreen({
    Key? key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.contacts,
    required this.onUpdateProfileImage,
    this.profileImage,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      SignInScreen(isDarkMode: _isDarkMode),
      SignUpScreen(isDarkMode: _isDarkMode),
      CalculatorScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      widget.onUpdateProfileImage(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'), // Replace with your app's title or use localization
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Sign In', // Replace with your localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Sign Up', // Replace with your localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator', // Replace with your localized string
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: Container(
          color: _isDarkMode ? Colors.grey[800] : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: const [Colors.blue, Colors.red],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Menu', // Replace with your localized string
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: widget.profileImage != null
                          ? FileImage(File(widget.profileImage!.path))
                          : AssetImage('assets/default_profile.png') as ImageProvider,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Select from Gallery'), // Replace with your localized string
                onTap: () {
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Picture'), // Replace with your localized string
                onTap: () {
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                title: Text('Dark Mode'), // Replace with your localized string
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                      _screens[0] = SignInScreen(isDarkMode: _isDarkMode);
                      _screens[1] = SignUpScreen(isDarkMode: _isDarkMode);
                      widget.onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.contacts),
                title: Text('Contacts'), // Replace with your localized string
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactsScreen(contacts: widget.contacts),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'), // Replace with your localized string
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('English'),
                  onTap: () {
                    widget.onLanguageChanged(Locale('en'));
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  child: Text('Español'),
                  onTap: () {
                    widget.onLanguageChanged(Locale('es'));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContactsScreen extends StatelessWidget {
  final List<Contact> contacts;

  const ContactsScreen({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'), // Replace with your localized string
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? 'No Name'), // Replace with your localized string
          );
        },
      ),
    );
  }
}
