import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:fitelevate/src/constants/path_constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/text_constants.dart';
import '../Login/login_screen.dart';
import 'auth_service.dart';
import 'form_error_provider.dart';



class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPhoneField = false;
  String _countryCode = '+91'; // default country code

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final phone = _phoneController.text;

    final formErrorProvider = Provider.of<FormErrorProvider>(context, listen: false);

    formErrorProvider.validateFields(name, email, password, phone, _isPhoneField);

    if (formErrorProvider.isValid) {
      if (_isPhoneField) {
        AuthService().createAccountWithPhone(name,email, phone, _countryCode, context);
      } else {
        AuthService().createAccountWithEmail(name, email, password, context);
      }
      // Save user session
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Set the session to logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    final formErrorProvider=Provider.of<FormErrorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Create your account')),
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorConstants.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage(PathConstants.logo),width: 50,height: 50,),
                  Text(
                    TextConstants.fitelevate,
                    style:GoogleFonts.arvo(
                      fontSize:30,
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: const OutlineInputBorder(),
                  errorText: formErrorProvider.nameError,
                ),
              ),
              const SizedBox(height: 16),
              if (!_isPhoneField) ...[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    errorText: formErrorProvider.emailError,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: const OutlineInputBorder(),
                          prefixIcon: CountryCodePicker(
                            onChanged: (countryCode) {
                              setState(() {
                                _countryCode = countryCode.dialCode!;
                              });
                            },
                            initialSelection: 'IN',
                            favorite: const ['+91', 'IN'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                          errorText: formErrorProvider.phoneError,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ],
              if (!_isPhoneField) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: formErrorProvider.isObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    errorText: formErrorProvider.passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        formErrorProvider.isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: formErrorProvider.togglePasswordVisibility,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:WidgetStatePropertyAll(ColorConstants.primaryColor),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                  padding: WidgetStatePropertyAll(const EdgeInsets.symmetric(horizontal: 75, vertical: 15)),
                ),
                onPressed: _handleCreateAccount,
                child: const Text(
                  TextConstants.signUp,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              const Text(TextConstants.connectWith, style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => AuthService().signInWithGoogle(context),
                        child: ClipOval(
                          child: Image.asset(PathConstants.google, width: 45,height: 45),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPhoneField = !_isPhoneField;
                          });
                        },
                        child: ClipOval(
                          child: Image.asset(
                            _isPhoneField ? PathConstants.mail : PathConstants.phone, width:45,height: 45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(TextConstants.haveAccount, style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text(
                      TextConstants.signIn,
                      style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
