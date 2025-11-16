import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ncp_page.dart';
import 'drug_study_page.dart';
import 'reflection_page.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  final List<Map<String, dynamic>> _pages = [
    {"title": "Nursing Care Plan", "icon": Icons.assignment, "widget": const NCPPage()},
    {"title": "Drug Study", "icon": Icons.medication, "widget": const DrugStudyPage()},
    {"title": "Reflection", "icon": Icons.book, "widget": const ReflectionPage()},
  ];

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("My Profile",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.shade400,
                  radius: 30,
                  child: const Icon(Icons.person, color: Colors.white, size: 35),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.email ?? "student@email.com",
                          style: const TextStyle(fontSize: 14)),
                      const Text("Nursing Student",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text("Account Details:",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 8),
            Text("UID: ${FirebaseAuth.instance.currentUser?.uid ?? 'Unknown'}",
                style: const TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text("Status: Active",
                style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: isMobile
          ? Drawer(
              backgroundColor: const Color(0xFF12355B),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF12355B)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/building.png',
                          width: 45,
                          height: 45,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Nurses' Notes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      '\u{1FA7A}',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    title: const Text(
                      "Nursing Care Plan",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/icons/plus.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                    selected: _selectedIndex == 0,
                    selectedTileColor: Colors.teal.shade700,
                    onTap: () {
                      setState(() => _selectedIndex = 0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Text(
                      '\u{1F48A}',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    title: const Text(
                      "Drug Study",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/icons/plus.png',
                        width: 22,
                      height: 22,
                      ),
                    ),
                    selected: _selectedIndex == 1,
                    selectedTileColor: Colors.teal.shade700,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Text(
                      '\u{1F4DD}',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    title: const Text(
                      "Reflection",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/icons/plus.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                    selected: _selectedIndex == 2,
                    selectedTileColor: Colors.teal.shade700,
                    onTap: () {
                      setState(() => _selectedIndex = 2);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(color: Colors.white38, height: 1),
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/profile.png',
                      width: 22,
                      height: 22,
                    ),
                    title: const Text(
                      "Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: _selectedIndex == 3,
                    selectedTileColor: Colors.teal.shade700,
                    onTap: () {
                      setState(() => _selectedIndex = 3);
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  const Divider(color: Colors.white54, height: 1),
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/logout.png',
                      width: 22,
                      height: 22,
                    ),
                    title: const Text(
                      "Logout",
                       style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _logout(),
                  ),
               ],
              ),
            )
          : null,

      body: Row(
        children: [
          if (!isMobile)
            NavigationRail(
              backgroundColor: const Color(0xFF12355B),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  children: [
                    const Icon(Icons.school, color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    const Text("Nurses' Notes",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              destinations: [
                NavigationRailDestination(
                      icon: const Text("🩺", style: TextStyle(fontSize: 24)),
                      label: const Text("NCP",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                NavigationRailDestination(
                      icon: const Text("💊", style: TextStyle(fontSize: 24)),
                      label: const Text("Drug Study",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                NavigationRailDestination(
                      icon: const Text("📝", style: TextStyle(fontSize: 24)),
                      label: const Text("Reflection",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),

          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isMobile)
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          Text(
                            _pages[_selectedIndex]["title"],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      PopupMenuButton<int>(
                        tooltip: 'User Menu',
                        offset: const Offset(0, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onSelected: (value) {
                          if (value == 1) {
                            _showProfileDialog(context);
                          } else if (value == 2) {
                            _logout();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: const [
                                Icon(Icons.person, color: Colors.black54),
                                SizedBox(width: 8),
                                Text("My Profile"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.redAccent),
                                SizedBox(width: 8),
                                Text("Logout"),
                              ],
                            ),
                          ),
                        ],
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.teal.shade400,
                              radius: 18,
                              child: const Icon(Icons.person,
                                  color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.email ?? "Student",
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Text("Online",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 11)),
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black54),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2)
                      ],
                    ),
                    child: _pages[_selectedIndex]["widget"],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}