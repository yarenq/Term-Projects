import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../../services/table_service.dart';
import '../../models.dart';
import 'table_detail_screen.dart';
import 'user_login_screen.dart';
import 'table_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade300,
              Colors.orange.shade600,
              Colors.orange.shade800,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              _buildBackgroundCircles(),

              // Main content
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo and title section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              // Logo container
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.restaurant_menu,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Title
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Colors.white, Colors.white70],
                                ).createShader(bounds),
                                child: const Text(
                                  'Restaurant\nManagement',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.2,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                'Choose your role to continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Login buttons
                        SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              _buildModernLoginButton(
                                context,
                                'Customer',
                                Icons.person_outline,
                                Colors.green.shade600,
                                    () => _handleCustomerLogin(context),
                                'Access menu and place orders',
                              ),
                              const SizedBox(height: 20),
                              _buildModernLoginButton(
                                context,
                                'Kitchen Staff',
                                Icons.kitchen_outlined,
                                Colors.blue.shade600,
                                    () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const UserLoginScreen(role: 'staff'),
                                  ),
                                ),
                                'Manage orders and kitchen',
                              ),
                              const SizedBox(height: 20),
                              _buildModernLoginButton(
                                context,
                                'Admin',
                                Icons.admin_panel_settings_outlined,
                                Colors.red.shade600,
                                    () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const UserLoginScreen(role: 'admin'),
                                  ),
                                ),
                                'System administration',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: -150,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernLoginButton(
      BuildContext context,
      String title,
      IconData icon,
      Color accentColor,
      VoidCallback onPressed,
      String subtitle,
      ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.85),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: accentColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToHomeScreen(BuildContext context, int initialIndex, {int? userType}) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(initialIndex: initialIndex, userType: userType),
      ),
    );
  }

  Future<void> _handleCustomerLogin(BuildContext context) async {
    // Directly navigate to table selection screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TableSelectionScreen(),
      ),
    );
  }
}