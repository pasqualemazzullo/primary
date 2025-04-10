import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../register_pet/screens/register_pet_1_screen.dart';
import 'welcome_dialogs.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.orange, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 1),
                _buildWelcomeImage(),
                const SizedBox(height: 20),
                _buildWelcomeText(),
                const SizedBox(height: 16),
                _buildSubtitleText(),
                const SizedBox(height: 32),
                _buildLoginButton(context),
                const SizedBox(height: 16),
                _buildGuestButton(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeImage() {
    return Stack(
      alignment: Alignment.center,
      children: [Image.asset('assets/welcome_cat.png', height: 410)],
    );
  }

  Widget _buildWelcomeText() {
    return const Text(
      'I tuoi pelosetti sempre sotto controllo',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 31,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSubtitleText() {
    return const Text(
      'Ti offriamo tutto ciò di cui hai bisogno in un\'unica, semplice app.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        WelcomeDialogs.showDevelopmentDialog(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
      ),
      child: const Text(
        'Accedi',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildGuestButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPet1Screen()),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.grey600,
        minimumSize: const Size(double.infinity, 56),
        side: const BorderSide(color: AppColors.grey300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.transparent,
      ),
      child: const Text(
        'Continua come ospite',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
