// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Application Entry Point ---
void main() {
  runApp(const MyApp());
}

// --- Application Wrapper (The Root Widget) ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carenet Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Text', 
      ),
      home: const QRCodeBindingPage(), 
    );
  }
}

// --- The Page Widget (Your QR Code Binding Interface) ---

class QRCodeBindingPage extends StatefulWidget {
  const QRCodeBindingPage({super.key});

  @override
  State<QRCodeBindingPage> createState() => _QRCodeBindingPageState();
}

class _QRCodeBindingPageState extends State<QRCodeBindingPage> {
  String? _permissionStatus;

  void _handlePermission(String status) {
    setState(() {
      _permissionStatus = status;
    });
    print('Permission status: $status');
  }

  // Helper function to create the permission option buttons
  Widget _buildPermissionButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0x33007AFF), 
            width: 0.5, 
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color(0xFF007AFF),
            letterSpacing: -0.41,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Helper function for the corner segment with radius
  Widget _cornerSegment({
    required Alignment alignment, 
    required bool isHorizontal,
    required double length, 
    required double thickness,
  }) {
    final bool isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final bool isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    if (isHorizontal) {
      return Positioned(
        top: isTop ? 0 : null,
        bottom: isTop ? null : 0,
        left: isLeft ? 0 : null,
        right: isLeft ? null : 0,
        child: Container(
          width: length,
          height: thickness,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    } else {
      return Positioned(
        top: isTop ? 0 : null,
        bottom: isTop ? null : 0,
        left: isLeft ? 0 : null,
        right: isLeft ? null : 0,
        child: Container(
          width: thickness,
          height: length,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(), 
        ),
        title: const Text(
          'Bind via QR code',
          style: TextStyle(
            color: Color(0xFF007AFF),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.41,
          ),
        ),
        centerTitle: true,
        actions: [
          // DONE BUTTON: Filled blue button with white text and rounded corners.
          Padding(
            // Reduced right margin slightly
            padding: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
            child: TextButton(
              onPressed: () {
                print('Done pressed');
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF), // Blue background
                // 💡 Reduced Padding to decrease the button size
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.41, // Added for iOS text style
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                // Available Devices Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Devices',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: -0.41,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.black, size: 24),
                            onPressed: () {},
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.qr_code_scanner, color: Colors.black, size: 24),
                            onPressed: () {},
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // QR Code Scanner Area - Flexible height
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C7278),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 35, 
                        height: 35,
                        child: Stack(
                          children: [
                            // Top-Left L
                            _cornerSegment(alignment: Alignment.topLeft, isHorizontal: true, length: 14, thickness: 3),
                            _cornerSegment(alignment: Alignment.topLeft, isHorizontal: false, length: 14, thickness: 3),
                            
                            // Top-Right L
                            _cornerSegment(alignment: Alignment.topRight, isHorizontal: true, length: 14, thickness: 3),
                            _cornerSegment(alignment: Alignment.topRight, isHorizontal: false, length: 14, thickness: 3),

                            // Bottom-Left L
                            _cornerSegment(alignment: Alignment.bottomLeft, isHorizontal: true, length: 14, thickness: 3),
                            _cornerSegment(alignment: Alignment.bottomLeft, isHorizontal: false, length: 14, thickness: 3),

                            // Bottom-Right L
                            _cornerSegment(alignment: Alignment.bottomRight, isHorizontal: true, length: 14, thickness: 3),
                            _cornerSegment(alignment: Alignment.bottomRight, isHorizontal: false, length: 14, thickness: 3),

                            // CENTER LINE
                            Center(
                              child: Container(
                                width: 18, 
                                height: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6),
                                  borderRadius: BorderRadius.circular(2), 
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Spacer to push permission dialog down
                const Spacer(flex: 1),
                
                // Permission Dialog Area - Compact size
                Container(
                  width: screenWidth - 32,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB), 
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Allow Carenet Health App to take pictures and record video?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400, 
                          color: Colors.black,
                          height: 1.3,
                          letterSpacing: -0.08,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      
                      // Permission Buttons 
                      _buildPermissionButton('While using this app', () => _handlePermission('while_using')),
                      const SizedBox(height: 7),
                      _buildPermissionButton('Only this time', () => _handlePermission('only_once')),
                      const SizedBox(height: 7),
                      _buildPermissionButton('Do not allow', () => _handlePermission('deny')),
                    ],
                  ),
                ),
                
                // Bottom indicator (iOS style)
                Container(
                  height: 5,
                  width: 134,
                  margin: const EdgeInsets.only(bottom: 8, top: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}