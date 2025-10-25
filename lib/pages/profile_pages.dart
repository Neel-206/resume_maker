import 'dart:ui';
import 'package:flutter/material.dart';

class profilepage extends StatefulWidget {
  final VoidCallback? onNext;
  const profilepage({super.key, this.onNext});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  bool showAdditionalFields = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Add your up-to-date contact information so employers and recruiters can easily reach you.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.40),
                            Colors.white.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildTextField('First Name', firstNameController),
                          const SizedBox(height: 12),
                          _buildTextField('Last Name', lastNameController),
                          const SizedBox(height: 12),
                          _buildTextField('Email', emailController),
                          const SizedBox(height: 12),
                          _buildTextField('Phone Number', phoneController),
                          const SizedBox(height: 18),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showAdditionalFields = !showAdditionalFields;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Additional Information',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 600),
                                  turns: showAdditionalFields ? 0.5 : 0.0,
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClipRect(
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: showAdditionalFields
                                  ? Column(
                                      children: [
                                        Divider(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        const SizedBox(height: 10),
                                        buildAdditionalFields(
                                          'Country',
                                          countryController,
                                        ),
                                        const SizedBox(height: 12),
                                        buildAdditionalFields(
                                          'City',
                                          cityController,
                                        ),
                                        const SizedBox(height: 12),
                                        buildAdditionalFields(
                                          'Address',
                                          addressController,
                                        ),
                                        const SizedBox(height: 12),
                                        buildAdditionalFields(
                                          'Pincode',
                                          pincodeController,
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          onPressed: widget.onNext,
          child: Text('Next'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 62),
            backgroundColor: Color.fromARGB(255, 111, 101, 247),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
            ),
            elevation: 8,
            shadowColor: Colors.deepPurpleAccent.withOpacity(0.6),
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller, // Assign controller here
      decoration: InputDecoration(
        labelText: ' $label',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget buildAdditionalFields(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: ' $label',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
