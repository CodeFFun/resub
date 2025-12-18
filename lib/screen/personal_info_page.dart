import 'package:flutter/material.dart';
import 'package:resub/screen/home_screen.dart';
import 'package:resub/widgets/my_button.dart';
import 'package:resub/widgets/my_input_form_field.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Full Name
                MyInputFormField(
                  controller: _fullNameController,
                  labelText: 'Full name',
                  hintText: 'Enter your full name',
                  icon: const Icon(Icons.person_outline),
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: 25),

                // Phone Number
                MyInputFormField(
                  controller: _phoneController,
                  labelText: 'Phone number',
                  hintText: 'Enter your phone number',
                  icon: const Icon(Icons.phone_outlined),
                  inputType: TextInputType.phone,
                ),
                const SizedBox(height: 25),

                // Alternate Email
                MyInputFormField(
                  controller: _emailController,
                  labelText: 'Alternate email',
                  hintText: 'Enter your email',
                  icon: const Icon(Icons.email_outlined),
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25),

                // Date of Birth
                MyInputFormField(
                  controller: _dobController,
                  labelText: 'Date of birth',
                  hintText: 'Select your date of birth',
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
                const SizedBox(height: 25),

                // Gender Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Select your gender',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.wc_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                    items: ['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 45),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: MyButton(
                    text: "Next",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
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
