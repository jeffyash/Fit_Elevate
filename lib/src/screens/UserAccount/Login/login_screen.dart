import 'package:country_code_picker/country_code_picker.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import 'package:fitelevate/src/screens/UserAccount/Login/login_form_error.dart';
import 'package:fitelevate/src/screens/UserAccount/SignUp/create_account_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/path_constants.dart';
import '../ForgotPassword/forgot_password.dart';
import 'login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPhoneField = false;
  String _countryCode = '+91'; // default country code

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _handleLogin() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneController.text;
    final formErrorProvider = Provider.of<LoginFormErrorProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    formErrorProvider.validateFields( email, password, phoneNumber, _isPhoneField);
    if (formErrorProvider.isValid) {
      if (_isPhoneField) {
       loginProvider.signInWithPhone( phoneNumber, _countryCode, context);
      } else {
        loginProvider.login(email, password, context);
      }
      // Save user session
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Set the session to logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Form(
                child: Column(
                  children: [
                    // TextField(
                    //   controller: _nameController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Name',
                    //     border: const OutlineInputBorder(),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                  if(!_isPhoneField)...[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email Address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Consumer<LoginProvider>(
                      builder: (context, provider, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: provider.isObscured,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                provider.isObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: provider.togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    Consumer<LoginProvider>(
                      builder: (context, provider, child) {
                        return provider.errorMessage != null
                            ? Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                            : const SizedBox.shrink();
                      },
                    ),
                  ]else ...[
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
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            ColorConstants.primaryColor),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                        padding: WidgetStatePropertyAll(
                            const EdgeInsets.symmetric(
                                horizontal: 75, vertical: 15)),
                      ),
                      onPressed: _handleLogin,
                      child: const Text(
                        "Log In",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.indigo[600],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  loginProvider.signInWithGoogle(context),
                              child: ClipOval(
                                child: Image.asset(PathConstants.google,
                                    width: 45, height: 45),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () =>
                            //       loginProvider.signInWithFacebook(context),
                            //   child: ClipOval(
                            //     child: Image.asset(PathConstants.facebook,
                            //         width: 45, height: 45),
                            //   ),
                            // ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccountPage()));
                            },
                            child: Text("Sign Up",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.primaryColor
                            ),),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

