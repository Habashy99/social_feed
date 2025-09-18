import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/providers/auth_providers.dart';
import 'package:social_feed/pages/home.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/widgets/custom_button.dart';
import 'package:social_feed/widgets/custom_text_field.dart';
import 'package:social_feed/widgets/image_input.dart';

class Signup extends HookConsumerWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameController = useTextEditingController(text: "");
    final emailController = useTextEditingController(text: "");
    final passwordController = useTextEditingController(text: "");
    final isObscured = useState(true);
    final selectedImage = useState<File?>(null);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 48, 87),
        title: Text(
          "Signup",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                "Register Account",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "Complete your details to continue",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      text: "Name",
                      controller: nameController,
                      validator:
                          (value) => value!.isEmpty ? "Missing Name" : null,
                    ),
                    SizedBox(height: 16),
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
                    ImageInput(
                      selectedImage: selectedImage.value,
                      onSelectImage: (image) {
                        selectedImage.value = image;
                      },
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 240,
                      child: CustomButton(
                        text: "Signup",
                        onPress: () async {
                          try {
                            final newUser = await ref.watch(
                              signupProvider((
                                email: emailController.text,
                                name: nameController.text,
                                password: passwordController.text,
                                image: selectedImage.value,
                              )).future,
                            );
                            if (newUser != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
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
                    SizedBox(height: 16),
                    SizedBox(
                      width: 240,
                      child: CustomButton(
                        text: "Login",
                        onPress: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
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
      ),
    );
  }
}
