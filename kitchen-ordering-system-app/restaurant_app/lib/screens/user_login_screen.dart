import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
import 'login_screen.dart';

class UserLoginScreen extends StatefulWidget {
  final String role; // 'admin' veya 'staff'
  const UserLoginScreen({super.key, required this.role});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': _idController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
    );
    setState(() {
      _loading = false;
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['role'] == widget.role) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              initialIndex: 0,
              userType: widget.role == 'admin' ? 2 : 1,
            ),
          ),
        );
      } else {
        setState(() {
          _error = 'Role mismatch!';
        });
      }
    } else {
      setState(() {
        _error = 'Invalid ID or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${widget.role[0].toUpperCase()}${widget.role.substring(1)} Login'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0),
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
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
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                ),
              ),
            ],
          ),

        ),

      ),
    );
  }
} 