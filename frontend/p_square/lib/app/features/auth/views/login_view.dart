import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/auth/controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LoginView')),

      body: SafeArea(child: Text('LoginViewController')),
    );
  }
}
