import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/outline_button_provider.dart';
import '../widgets/sign_in_form.dart';
import '../widgets/send_code_form.dart';
import '../widgets/terms_and_privacy_notice.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleLogin(BuildContext context, AuthMethod type) async {
    try {
      await context.read<AuthProvider>().loginSocial(type);
    } catch (e) {
      debugPrint('Error en login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    const Color titleColor = Color(0xFF1A2B47);

    final String authType =
        (dotenv.maybeGet('AUTH_TYPE') ?? 'PASSENGER').toUpperCase().trim();
    final bool isAgentsMode = authType == 'AGENTS';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const SizedBox(height: 24),
                Image.network(
                  'https://app-agione-media-prod-use2-bbgph2ahe2gcg2ee.eastus2-01.azurewebsites.net/api/media/v1/files/download/c8cfd4b0794a4d81984cfd98a854e254',
                  width: 220,
                  height: 96,
                  fit: BoxFit.contain,
                  semanticLabel: 'Airport Butler',
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/airport_butler_login_logo.png',
                    width: 220,
                    height: 96,
                    fit: BoxFit.contain,
                    semanticLabel: 'Airport Butler',
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  isAgentsMode ? 'Concierges Sign In' : 'Passenger Sign In',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: titleColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                // ── Botones de proveedores sociales ──
                if (isAgentsMode) ...[
                  // AGENTS: solo Microsoft
                  Wrap(
                    runSpacing: 10,
                    children: [
                      /*OutlineButtonProvider(
                        label: 'Continue with Microsoft',
                        icon: FontAwesomeIcons.microsoft,
                        iconColor: const Color(0xFF00A4EF),
                        isLoading: authProvider.isMethodLoading(AuthMethod.microsoft),
                        onPressed: () => _handleLogin(context, AuthMethod.microsoft),
                      ),
                      OutlineButtonProvider(
                        label: 'Continue with Apple',
                        icon: FontAwesomeIcons.apple,
                        iconColor: const Color(0xFF000000),
                        isLoading: authProvider.isMethodLoading(AuthMethod.apple),
                        onPressed: () => _handleLogin(context, AuthMethod.apple),
                      ),*/
                    ],
                  ),
                ] else ...[
                  // PASSENGER: Google, Microsoft, Facebook, Apple
                  // TO-DO
                  Wrap(
                    runSpacing: 10,
                    children: [
                       OutlineButtonProvider(
                         label: 'Continue with Google',
                         icon: FontAwesomeIcons.google,
                         isLoading: authProvider.isMethodLoading(AuthMethod.google),
                         onPressed: () => _handleLogin(context, AuthMethod.google),
                      ),
                      OutlineButtonProvider(
                        label: 'Continue with Microsoft',
                        icon: FontAwesomeIcons.microsoft,
                        iconColor: const Color(0xFF00A4EF),
                        isLoading: authProvider.isMethodLoading(AuthMethod.microsoft),
                        onPressed: () => _handleLogin(context, AuthMethod.microsoft),
                      ),
                      // OutlineButtonProvider(
                      //   label: 'Continue with Facebook',
                      //   icon: FontAwesomeIcons.facebook,
                      //   iconColor: const Color(0xFF1877F2),
                      //   isLoading: false,
                      //   onPressed: () {},
                      // ),
                      OutlineButtonProvider(
                         label: 'Continue with Apple',
                         icon: FontAwesomeIcons.apple,
                         iconColor: const Color(0xFF000000),
                         isLoading: authProvider.isMethodLoading(AuthMethod.apple),
                         onPressed: () => _handleLogin(context, AuthMethod.apple),
                      ),
                    ],
                  ),
                ],

                // ── Divisor "or" ──
                /*const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(color: Color(0xFFCBD5E1), thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17),
                        child: Text(
                          'or',
                          style: TextStyle(
                              color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Color(0xFFCBD5E1), thickness: 1),
                      ),
                    ],
                  ),
                ),*/

                // ── Formulario según modo ──
                if (isAgentsMode)
                  const SignInForm()   // Email + Password + Sign In
                else
                  const SendCodeForm(), // Solo Email + Send Code (OTP)

                const SizedBox(height: 40),
                const TermsAndPrivacyNotice(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
