import 'package:expense_wise/app/services/security_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecuritySettingsView extends StatefulWidget {
  const SecuritySettingsView({super.key});

  @override
  State<SecuritySettingsView> createState() => _SecuritySettingsViewState();
}

class _SecuritySettingsViewState extends State<SecuritySettingsView> {
  final SecurityService _securityService = Get.find<SecurityService>();
  String _newPin = '';
  String _confirmPin = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E6E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Security Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAppLockSection(),
            const SizedBox(height: 24),
            if (_securityService.isLockEnabled.value) ...[
              _buildLockTypeSection(),
              const SizedBox(height: 24),
              _buildAutoLockSection(),
              const SizedBox(height: 24),
            ],
            _buildPrivacySection(),
            const SizedBox(height: 24),
            _buildResetSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLockSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.lock_shield, color: Color(0xFF002E6E)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'App Lock',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              CupertinoSwitch(
                value: _securityService.isLockEnabled.value,
                onChanged: (value) => _toggleAppLock(value),
                activeColor: const Color(0xFF00BAF2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Require authentication to access the app',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildLockTypeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lock Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...LockType.values.map((type) {
            return RadioListTile<LockType>(
              title: Text(type.displayName),
              value: type,
              groupValue: _securityService.lockType.value,
              onChanged: (value) {
                if (value != null) {
                  _securityService.enableLock(value);
                }
              },
              activeColor: const Color(0xFF00BAF2),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _showChangePinDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BAF2),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Change PIN',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoLockSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Auto-Lock Timer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...AutoLockTimer.values.map((timer) {
            return RadioListTile<AutoLockTimer>(
              title: Text(timer.displayName),
              value: timer,
              groupValue: _securityService.autoLockTimer.value,
              onChanged: (value) {
                if (value != null) {
                  _securityService.setAutoLockTimer(value);
                }
              },
              activeColor: const Color(0xFF00BAF2),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.eye_slash, color: Color(0xFF002E6E)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Privacy Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              CupertinoSwitch(
                value: _securityService.isPrivacyMode.value,
                onChanged: (value) => _securityService.togglePrivacyMode(value),
                activeColor: const Color(0xFF00BAF2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Hide sensitive information in app switcher',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildResetSection() {
    return ElevatedButton(
      onPressed: _confirmReset,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Reset Security Settings',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _toggleAppLock(bool enabled) async {
    if (enabled) {
      await _showSetPinDialog();
    } else {
      await _securityService.disableLock();
    }
  }

  Future<void> _showSetPinDialog() async {
    _newPin = '';
    _confirmPin = '';

    await Get.dialog(
      AlertDialog(
        title: const Text('Set PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter PIN (4-6 digits)',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              onChanged: (value) => _newPin = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Confirm PIN'),
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              onChanged: (value) => _confirmPin = value,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (_newPin.length >= 4 && _newPin == _confirmPin) {
                await _securityService.setPin(_newPin);
                await _securityService.enableLock(LockType.pin);
                Get.back();
                Get.snackbar('Success', 'PIN set successfully');
              } else {
                Get.snackbar('Error', 'PINs do not match or are too short');
              }
            },
            child: const Text('Set PIN'),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePinDialog() async {
    _newPin = '';
    _confirmPin = '';

    await Get.dialog(
      AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'New PIN (4-6 digits)',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              onChanged: (value) => _newPin = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Confirm New PIN'),
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              onChanged: (value) => _confirmPin = value,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (_newPin.length >= 4 && _newPin == _confirmPin) {
                await _securityService.setPin(_newPin);
                Get.back();
                Get.snackbar('Success', 'PIN changed successfully');
              } else {
                Get.snackbar('Error', 'PINs do not match or are too short');
              }
            },
            child: const Text('Change PIN'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset() async {
    await Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Reset Security'),
        content: const Text(
          'This will reset all security settings including your PIN. Are you sure?',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await _securityService.resetSecurity();
              Get.back();
              Get.snackbar('Success', 'Security settings reset');
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
