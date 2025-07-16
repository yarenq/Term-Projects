import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/table_service.dart';
import '../../models.dart';
import 'table_detail_screen.dart';

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _tableNumberController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _tableNumberController.dispose();
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
                                width: 100,
                                height: 100,
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
                                  Icons.table_restaurant,
                                  size: 50,
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
                                  'Table Selection',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.2,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                'Please enter your table number',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Table input section
                        SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Table number input
                                TextField(
                                  controller: _tableNumberController,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Table Number (eg: Table 1)',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Colors.orange.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Colors.orange.shade600,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.table_restaurant,
                                      color: Colors.orange.shade600,
                                    ),
                                  ),
                                  onSubmitted: (_) => _handleTableSelection(),
                                ),

                                if (_errorMessage != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.red.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red.shade600,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 24),

                                // Continue button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleTableSelection,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.shade600,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.arrow_forward),
                                              SizedBox(width: 8),
                                              Text(
                                                'Enter',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Back button
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: TextButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
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

  Future<void> _handleTableSelection() async {
    final tableName = _tableNumberController.text.trim();
    
    if (tableName.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen masa numarasını giriniz';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tableService = Provider.of<TableService>(context, listen: false);
      await tableService.fetchTables();
      
      // Find table by name (case insensitive)
      final table = tableService.tables.firstWhere(
        (t) => t.name.toLowerCase() == tableName.toLowerCase(),
        orElse: () => throw Exception('Table not found'),
      );

      // Navigate to table detail screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TableDetailScreen(
              tableId: table.id, 
              isCustomer: true
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().contains('Table not found')
            ? 'Bu isimde bir masa bulunamadı. Lütfen masa numarasını kontrol ediniz.'
            : 'Bağlantı hatası. Lütfen tekrar deneyiniz.';
      });
    }
  }

  String _getStatusText(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return 'Müsait';
      case TableStatus.occupied:
        return 'Dolu';
      case TableStatus.reserved:
        return 'Rezerve';
      case TableStatus.outOfService:
        return 'Hizmet Dışı';
    }
  }
}