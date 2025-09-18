import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:social_feed/helpers/providers/auth_providers.dart';
import 'package:social_feed/pages/home.dart';
import 'package:social_feed/pages/signup.dart';
import 'package:social_feed/widgets/custom_button.dart';
import 'package:social_feed/widgets/custom_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Login extends HookConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController(text: "");
    final passwordController = useTextEditingController(text: "");
    final isObscured = useState(true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 48, 87),
        title: Text(
          "Login",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 48, 87),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Continue your journey",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 48, 87),
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    text: "Email",
                    controller: emailController,
                    validator:
                        (value) => value!.isEmpty ? "Missing Email" : null,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    isObscured: isObscured.value,
                    controller: passwordController,
                    validator:
                        (value) => value!.isEmpty ? "Missing password" : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        color: Colors.white,
                        isObscured.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        isObscured.value = !isObscured.value;
                      },
                    ),
                    text: "Password",
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 240,
                    child: CustomButton(
                      text: "Login",
                      onPress: () async {
                        try {
                          final loggedInUser = await ref.watch(
                            loginProvider((
                              email: emailController.text,
                              password: passwordController.text,
                            )).future,
                          );
                          if (loggedInUser != null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 240,
                    child: CustomButton(
                      text: "Signup",
                      onPress: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Signup()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
