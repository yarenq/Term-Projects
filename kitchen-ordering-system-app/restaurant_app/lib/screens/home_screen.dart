import 'package:flutter/material.dart';
import 'table_management_screen.dart';
import 'kitchen_order_screen.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  final int? userType; // 0: müşteri, 1: personel, 2: admin

  const HomeScreen({
    super.key,
    this.initialIndex = 0,
    this.userType,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  int? get userType => widget.userType;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    if (widget.userType == 1) {
      // Personel: sadece Tables ve Kitchen
      _screens = [
        TableManagementScreen(userType: 1),
        const KitchenOrderScreen(userType: 1),
      ];
      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.table_bar),
          label: 'Tables',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.kitchen),
          label: 'Kitchen',
        ),
      ];
    } else {
      // Admin veya diğer: tüm sekmeler
      _screens = [
        TableManagementScreen(userType: widget.userType),
        const KitchenOrderScreen(userType: 2),
        const AdminScreen(),
      ];
      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.table_bar),
          label: 'Tables',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.kitchen),
          label: 'Kitchen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFff8a50), // Light orange
              Color(0xFFffab40), // Bright orange
              Color(0xFFffc947), // Orange-yellow
              Color(0xFFfff8e1), // Very light orange-yellow
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Custom elegant header section
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFff9800), // Orange
                    Color(0xFFffb74d), // Light orange
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ana başlık - Restaurant Management System
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ana başlık kısmı
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'RESTAURANT\n',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 2.5,
                                      height: 1.1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'MANAGEMENT\n',
                                    style: TextStyle(
                                      color: Color(0xFFffd54f), // Light yellow-orange
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.8,
                                      height: 1.1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'SYSTEM',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 2,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Subtitle
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.restaurant_menu,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Streamlined Operations',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Sağ taraf - Kullanıcı rolü ve butonlar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Kullanıcı tipi badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: widget.userType == 2
                                    ? [const Color(0xFFe65100), const Color(0xFFd84315)] // Orange gradient
                                    : widget.userType == 1
                                    ? [const Color(0xFFe65100), const Color(0xFFd84315)] // Amber-Orange gradient
                                    : [const Color(0xFFe65100), const Color(0xFFd84315)], // Light orange gradient
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.4),
                                  offset: const Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.userType == 2
                                      ? Icons.admin_panel_settings
                                      : widget.userType == 1
                                      ? Icons.kitchen
                                      : Icons.person,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.userType == 2
                                      ? 'ADMIN'
                                      : widget.userType == 1
                                      ? 'STAFF'
                                      : 'CUSTOMER',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Home button
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              tooltip: 'Çıkış Yap',
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Ana içerik alanı
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 8),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: _screens[_currentIndex],
                ),
              ),
            ),
          ],
        ),
      ),

      // Modern floating bottom navigation
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFff9800),
              Color(0xFFffb74d),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: _navItems,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFFFFFFFF),
            unselectedItemColor: Colors.white60,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}