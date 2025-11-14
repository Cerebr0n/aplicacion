import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controladores
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // Estado
  bool _isLoading = false;
  bool _codeSent = false;
  String? _verificationId;

  // Validación de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Paso 1: Enviar código OTP
  Future<void> _sendOTP() async {
    String email = _emailController.text.trim();
    String usuario = _usuarioController.text.trim();
    String password = _passwordController.text;

    if (!_isValidEmail(email)) {
      _showSnackBar('Ingresa un correo válido');
      return;
    }
    if (usuario.isEmpty || password.length < 6) {
      _showSnackBar('Usuario y contraseña (mín. 6 caracteres) requeridos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulamos envío de OTP (en producción usa Firebase Auth + email link o SMS)
      // Aquí usamos un "código simulado" para pruebas
      String simulatedCode = '123456'; // En producción: genera y envía por email

      await Future.delayed(const Duration(seconds: 2)); // Simula espera

      setState(() {
        _codeSent = true;
        _verificationId = 'simulated_verification_id';
      });

      _showSnackBar('Código enviado: 123456 (solo en modo prueba)');
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Paso 2: Verificar código y registrar
  Future<void> _verifyOTPAndRegister() async {
    if (_otpController.text != '123456') {
      _showSnackBar('Código incorrecto');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Registrar en Firestore
      await _firestore.collection('usuarios').add({
        'email': _emailController.text.trim(),
        'usuario': _usuarioController.text.trim(),
        'fecha_registro': FieldValue.serverTimestamp(),
        'verificado': true,
      });

      _showSnackBar('¡Registro exitoso!');
      
      // Limpiar
      _emailController.clear();
      _usuarioController.clear();
      _passwordController.clear();
      _otpController.clear();
      setState(() => _codeSent = false);
    } catch (e) {
      _showSnackBar('Error al guardar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usuarioController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', width: 120, height: 120),
                const SizedBox(height: 24),

                const Text(
                  'Crear cuenta',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Usuario
                TextField(
                  controller: _usuarioController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña (mín. 6)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Mostrar campo OTP si se envió el código
                if (_codeSent) ...[
                 PinCodeTextField(   //<=====================================checar esa madre, me dice que no hay contexto para usar esta variable
                    length: 6,
                    controller: _otpController,
                    onChanged: (value) {},
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.grey[200],
                      inactiveFillColor: Colors.grey[100],
                    ),
                    enableActiveFill: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOTPAndRegister,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verificar y Registrar'),
                  ),
                ] else
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendOTP,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Enviar Código'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}