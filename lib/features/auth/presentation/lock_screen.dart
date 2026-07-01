import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/auth_state_provider.dart';

/// The lock screen shown before the vault is accessible.
///
/// Matches the "Lock Screen - UX Perfect Redesign" design:
/// - Vaultly branding top-left, three-dot menu top-right
/// - Large fingerprint icon with layered lavender rings
/// - "Unlock to continue" heading
/// - Subtitle text
/// - Auth status message (animated)
/// - "Use PIN" primary button
/// - "Forgot authentication?" link
/// - Footer with version info
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with TickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isAuthenticating = false;
  String? _statusMessage;
  bool _isSuccess = false;
  bool _showPinField = false;

  // Animation for the status message fade-in
  late AnimationController _statusAnimController;
  late Animation<double> _statusFadeAnim;

  // Pulsating animations for the two outer rings
  late AnimationController _pulseOuterController;
  late Animation<double> _pulseOuterAnim;
  late AnimationController _pulseInnerController;
  late Animation<double> _pulseInnerAnim;
  Timer? _staggerTimer;

  @override
  void initState() {
    super.initState();
    _statusAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _statusFadeAnim = CurvedAnimation(
      parent: _statusAnimController,
      curve: Curves.easeOut,
    );

    // Outer ring pulse: slower, larger scale
    _pulseOuterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseOuterAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseOuterController, curve: Curves.easeInOut),
    );
    _pulseOuterController.repeat(reverse: true);

    // Inner ring pulse: slightly faster, staggered start
    _pulseInnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulseInnerAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseInnerController, curve: Curves.easeInOut),
    );
    // Stagger the inner ring by 400ms
    _staggerTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _pulseInnerController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _staggerTimer?.cancel();
    _pulseOuterController.dispose();
    _pulseInnerController.dispose();
    _statusAnimController.dispose();
    super.dispose();
  }

  // ── Biometric authentication ──────────────────────────────────────────
  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _statusMessage = null;
      _isSuccess = false;
    });
    _statusAnimController.reset();

    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        debugPrint(
          'Auth: Biometrics not available (canCheck=$canCheckBiometrics, supported=$isDeviceSupported)',
        );
        _showStatus('Biometrics not available on this device.', success: false);
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock your Vaultly vault',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate) {
        debugPrint('Auth: Success — unlocking vault');
        _showStatus('Authenticated. Access granted.', success: true);
        HapticFeedback.lightImpact();
        // Small delay so the user sees the success message.
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          ref.read(authStateProvider.notifier).unlock();
        }
      } else {
        debugPrint('Auth: User cancelled or failed');
        _showStatus('Authentication failed. Try again.', success: false);
      }
    } on PlatformException catch (e) {
      debugPrint('Auth error: ${e.code} – ${e.message}');
      _showStatus(e.message ?? 'Authentication error.', success: false);
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  void _showStatus(String message, {required bool success}) {
    if (!mounted) return;
    setState(() {
      _statusMessage = message;
      _isSuccess = success;
    });
    _statusAnimController.forward();
  }

  // ── Build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              Expanded(
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: .end,
                  children: [
                    _buildHeading(),
                    _buildSubtitle(),
                    SizedBox(height: 40),
                    _buildUsePinButton(),
                    _buildForgotLink(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  mainAxisAlignment: .center,
                  children: [
                    _buildFingerprintIcon(),
                    _buildStatusMessage(),
                    SizedBox(height: 30),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header: logo + three-dot menu ─────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Shield icon to match the Vaultly brand mark
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.lavenderLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text('Vaultly', style: AppTextStyles.brandLabel),
          ],
        ),
      ],
    );
  }

  // ── Fingerprint icon with two independently pulsating outer rings ─────
  Widget _buildFingerprintIcon() {
    return GestureDetector(
      onTap: _isAuthenticating ? null : _authenticateWithBiometrics,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring – lightest lavender, slower pulse
            ScaleTransition(
              scale: _pulseOuterAnim,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lavenderOuter,
                ),
              ),
            ),
            // Inner ring – slightly darker lavender, faster staggered pulse
            ScaleTransition(
              scale: _pulseInnerAnim,
              child: Container(
                width: 145,
                height: 145,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lavenderLight,
                ),
              ),
            ),
            // Static fingerprint circle (on top)
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: AppColors.lavenderMid.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lavenderMid.withValues(alpha: 0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.fingerprint,
                size: 52,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── "Unlock to continue" ──────────────────────────────────────────────
  Widget _buildHeading() {
    return Text(
      'Unlock to continue',
      style: AppTextStyles.heading1,
      textAlign: TextAlign.center,
    );
  }

  // ── Subtitle ──────────────────────────────────────────────────────────
  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Secure biometric verification is required\nto access your financial vault.',
        style: AppTextStyles.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  // ── Status message ("Authenticated. Access granted.") ─────────────────
  Widget _buildStatusMessage() {
    return SizedBox(
      height: 22,
      child: _statusMessage != null
          ? FadeTransition(
              opacity: _statusFadeAnim,
              child: Text(
                _statusMessage!,
                style: _isSuccess
                    ? AppTextStyles.statusSuccess
                    : AppTextStyles.statusSuccess.copyWith(
                        color: AppColors.error,
                      ),
                textAlign: TextAlign.center,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // ── "Use PIN" button / inline PIN field ────────────────────────────────
  Widget _buildUsePinButton() {
    if (_showPinField) {
      return _PinInputWidget(
        onSuccess: _handlePinSuccess,
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isAuthenticating
            ? null
            : () {
                setState(() => _showPinField = true);
              },
        icon: const Icon(Icons.keyboard_outlined, size: 20),
        label: Text('Use PIN', style: AppTextStyles.buttonPrimary),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _handlePinSuccess() {
    _showStatus('Authenticated. Access granted.', success: true);
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        ref.read(authStateProvider.notifier).unlock();
      }
    });
  }

  // ── "Forgot authentication?" link ─────────────────────────────────────
  Widget _buildForgotLink() {
    return TextButton(
      onPressed: () {
        // Placeholder – future: forgot authentication flow
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text('Forgot authentication?', style: AppTextStyles.linkText),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Text(
      'Vaultly v4.2.0 • Secured by Precision FinTech',
      style: AppTextStyles.footer,
      textAlign: TextAlign.center,
    );
  }
}

class _PinInputWidget extends StatefulWidget {
  final VoidCallback onSuccess;

  const _PinInputWidget({required this.onSuccess});

  @override
  State<_PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<_PinInputWidget> {
  late List<TextEditingController> _pinControllers;
  late List<FocusNode> _pinFocusNodes;
  String? _pinError;

  @override
  void initState() {
    super.initState();
    _pinControllers = List.generate(4, (_) => TextEditingController());
    _pinFocusNodes = List.generate(4, (_) => FocusNode());
    // Auto-focus the first PIN field after the frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _validatePin(String pin) {
    // TODO: Replace with actual stored PIN check from Hive
    const storedPin = '1234';

    if (pin == storedPin) {
      widget.onSuccess();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _pinError = 'Incorrect PIN. Try again.';
      });
      for (final c in _pinControllers) {
        c.clear();
      }
      _pinFocusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              width: 56,
              height: 64,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _pinControllers[index],
                focusNode: _pinFocusNodes[index],
                obscureText: true,
                obscuringCharacter: '●',
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: AppTextStyles.heading1.copyWith(fontSize: 24),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: _pinError != null
                      ? AppColors.error.withValues(alpha: 0.05)
                      : AppColors.lavenderOuter,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: _pinError != null
                          ? AppColors.error
                          : AppColors.lavenderMid,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: _pinError != null
                          ? AppColors.error
                          : AppColors.lavenderMid,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: _pinError != null
                          ? AppColors.error
                          : AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (_pinError != null) {
                    setState(() => _pinError = null);
                  }
                  if (value.length == 1 && index < 3) {
                    _pinFocusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _pinFocusNodes[index - 1].requestFocus();
                  }
                  // Auto-submit when all 4 digits entered
                  final pin = _pinControllers.map((c) => c.text).join();
                  if (pin.length == 4) {
                    _validatePin(pin);
                  }
                },
              ),
            );
          }),
        ),
        if (_pinError != null) ...[
          const SizedBox(height: 12),
          Text(
            _pinError!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
