import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reals/components/text_input_border.dart';
import 'package:reals/resources/auth_methods.dart';
import 'package:reals/responsive/mobile_screen_layout.dart';
import 'package:reals/responsive/responisve_layout_screen.dart';
import 'package:reals/responsive/web_screen_layout.dart';
import 'package:reals/screens/login_screen.dart';
import 'package:reals/utils/colors.dart';
import 'package:reals/utils/utils.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  ImageProvider<Object>? getProfileImageProvider() {
    if (_image == null) {
      return const NetworkImage(
        'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
      );
    } else {
      return MemoryImage(_image!);
    }
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String authResult = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (authResult != 'success') {
      showSnackBar(context, authResult);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                color: primaryColor,
                height: 75,
              ),
              const SizedBox(height: 75),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: getProfileImageProvider(),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 95,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextInputFramed(
                hint: "Enter Username",
                bottomPadding: 45,
                controller: _usernameController,
              ),
              TextInputFramed(
                hint: "Enter Email",
                bottomPadding: 45,
                controller: _emailController,
              ),
              TextInputFramed(
                hint: "Enter Password",
                bottomPadding: 45,
                controller: _passwordController,
              ),
              TextInputFramed(
                hint: "enter your bio",
                controller: _bioController,
              ),
              const SizedBox(
                height: 14,
              ),
              ElevatedButton(
                onPressed: signUpUser,
                style: const ButtonStyle(),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Sign In'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                    child: const Text("Do you have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
