import 'package:expense_wise/app/services/security_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final SecurityService _securityService = Get.find<SecurityService>();
  String _pin = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _tryBiometric();
  }

  Future<void> _tryBiometric() async {
    if (_securityService.lockType.value == LockType.biometric ||
        _securityService.lockType.value == LockType.both) {
      final canUseBiometric = await _securityService.isBiometricAvailable();
      if (canUseBiometric) {
        final authenticated = await _securityService
            .authenticateWithBiometric();
        if (authenticated) {
          _unlock();
        }
      }
    }
  }

  void _onNumberPressed(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin += number;
        _isError = false;
      });

      if (_pin.length == 4 || _pin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    final isValid = await _securityService.verifyPin(_pin);
    if (isValid) {
      _unlock();
    } else {
      setState(() {
        _isError = true;
        _pin = '';
      });
    }
  }

  void _unlock() {
    _securityService.unlockApp();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002E6E),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // App Logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.lock_shield_fill,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            // Title
            const Text(
              'Enter Your PIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            if (_isError)
              const Text(
                'Incorrect PIN. Try again.',
                style: TextStyle(fontSize: 14, color: Colors.redAccent),
              ),
            const SizedBox(height: 32),
            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _pin.length
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    border: Border.all(
                      color: _isError ? Colors.redAccent : Colors.white,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
            // Number Pad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildNumberRow(['1', '2', '3']),
                  const SizedBox(height: 16),
                  _buildNumberRow(['4', '5', '6']),
                  const SizedBox(height: 16),
                  _buildNumberRow(['7', '8', '9']),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBiometricButton(),
                      _buildNumberButton('0'),
                      _buildDeleteButton(),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildNumberButton(number)).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onNumberPressed(number),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return FutureBuilder<bool>(
      future: _securityService.isBiometricAvailable(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox(width: 70, height: 70);
        }

        return InkWell(
          onTap: _tryBiometric,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00BAF2).withValues(alpha: 0.2),
            ),
            child: const Icon(
              CupertinoIcons.hand_raised_fill,
              color: Color(0xFF00BAF2),
              size: 30,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: _onDeletePressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        child: const Icon(
          CupertinoIcons.delete_left,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
